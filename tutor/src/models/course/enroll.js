import React from 'react';
import {
  BaseModel, identifiedBy, field, identifier, computed, session,
} from 'shared/model';
import { action, when, observable } from 'mobx';
import { get, pick, isEmpty } from 'lodash';
import { Redirect } from 'react-router-dom';
import S from '../../helpers/string';
import Router from '../../../src/helpers/router';
import Courses from '../courses-map';
import Activity from 'shared/components/staxly-animation';
import Enroll from '../../../src/components/enroll';
import Course from '../course';

export default
@identifiedBy('course/student')
class CourseEnrollment extends BaseModel {

  @identifier id;
  @field enrollment_code;

  @field student_identifier;
  @session pendingEnrollmentCode;
  @session originalEnrollmentCode;
  @session({ type: 'object' }) to = {};
  @session status;
  @session({ type: 'object' }) router;
  @observable isComplete = false;
  @observable courseToJoin;
  @observable isLoadingCourses;
  @observable courses = Courses;

  constructor(attrs = {}) {
    super(attrs);
    if (attrs.courses) { this.courses = attrs.courses; }
    this.originalEnrollmentCode = this.enrollment_code;
    when(
      () => this.isRegistered,
      () => this.fetchCourses(),
    );
  }

  @computed get bodyContents() {
    if (this.isLoading) {
      return <Activity isLoading={true} />;
    } else if (this.isFromLms && false === this.courseIsLmsEnabled) {
      return this.renderComponent('invalidLMS');
    } else if (!this.isFromLms && true === this.courseIsLmsEnabled) {
      return this.renderComponent('invalidLinks');
    } else if (this.isTeacher) {
      return this.renderComponent('invalidTeacher');
    } else if (this.isInvalid) {
      return this.renderComponent('invalidCode');
    } else if (this.isComplete) {
      if (this.courseId) {
        return <Redirect to={Router.makePathname('dashboard', { courseId: this.courseId })} />;
      } else {
        // the BE says we're registered but we didn't find the course
        // most likely because they're coming from LMS or have a non-standard enrollment
        return <Redirect to={Router.makePathname('myCourses')} />;
      }
    } else if (!isEmpty(this.api.errors)) {
      if (this.api.errors.dropped_student) {
        return this.renderComponent('droppedStudent');
      } else if (this.api.errors.course_ended) {
        return this.renderComponent('courseEnded');
      } else {
        return this.renderComponent('unknownError');
      }
    } else if (this.needsPeriodSelection) {
      return this.renderComponent('selectPeriod');
    } else {
      return this.renderComponent('studentIDForm');
    }
  }

  renderComponent(name) {
    const Tag = Enroll.Components[name];
    return <Tag enrollment={this} errors={this.api.errors} />;
  }

  @action.bound
  selectPeriod(period) {
    this.pendingEnrollmentCode = period.enrollment_code;
  }

  @computed get periodIsSelected() {
    return Boolean(this.pendingEnrollmentCode);
  }

  @action.bound
  onSubmitPeriod() {
    this.courseToJoin = null;
    this.enrollment_code = this.pendingEnrollmentCode;
    this.create();
  }

  @computed get courseIsLmsEnabled() {
    return this.courseToJoin ?
      this.courseToJoin.is_lms_enabled : get(this, 'to.course.is_lms_enabled', null);
  }

  @action.bound
  onCancel() {
    this.router.history.push(Router.makePathname('myCourses'));
  }

  @action.bound
  onCancelStudentId() {
    this.student_identifier = '';
    this.confirm();
  }

  @action.bound
  onStudentIdContinue() {
    this.confirm();
  }

  @computed get courseName() {
    if (this.isTeacher) {
      return get(this.api.errors, 'is_teacher.data.course_name', '');
    }
    return get(this, 'to.course.name', '');
  }

  @computed get course() {
    return this.courses.array.find(c =>
      c.periods.find(p =>
        p.enrollment_code == this.enrollment_code
      )
    );
  }

  @computed get courseId() {
    return get(this, 'to.course.id', this.course ? this.course.id : '');
  }

  @computed get isPending() {
    return Boolean(isEmpty(this.api.errors) && isEmpty(this.to));
  }

  @computed get isInvalid() {
    return Boolean(this.api.errors && this.api.errors.invalid_enrollment_code);
  }

  @computed get isTeacher() {
    return Boolean(get(this.api.errors, 'is_teacher'));
  }

  @computed get isRegistered() {
    return Boolean(get(this.api.errors, 'already_enrolled') || this.status == 'processed');
  }

  @computed get isLoading() {
    return Boolean(this.api.isPending || this.isLoadingCourses);
  }

  @computed get needsPeriodSelection() {
    return Boolean(this.isFromLms && S.isUUID(this.enrollment_code));
  }

  @computed get isFromLms() {
    return S.isUUID(this.originalEnrollmentCode);
  }

  fetchCourses() {
    this.isLoadingCourses = true;
    this.courses.fetch().then(() => {
      if (this.course) { // should always be set but maybe the BE messes up and doesn't return the new course yet?
        this.course.studentTasks.expecting_assignments_count = get(this, 'to.period.assignments_count', 0);
      }
      this.isLoadingCourses = false;
      this.isComplete = true;
    });
  }

  // called by api
  @action create() {
    if (this.needsPeriodSelection) {
      this.courseToJoin = new Course({});
      return { method: 'GET', url: `enrollment/${this.originalEnrollmentCode}/choices` };
    }
    return { data: pick(this, 'enrollment_code') };
  }

  @action onEnrollmentCreate({ data }) {
    if (this.needsPeriodSelection) {
      if (!this.courseToJoin) {
        this.courseToJoin = new Course(data);
      } else {
        this.courseToJoin.update(data);
      }
      if (this.courseToJoin.periods.length == 1) {
        this.enrollment_code = this.courseToJoin.periods[0].enrollment_code;
        this.create();
      }
    } else {
      this.update(data);
    }
  }

  confirm() {
    return { data: pick(this, 'student_identifier') };
  }

};
