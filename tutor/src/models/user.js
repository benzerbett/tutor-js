import {
  BaseModel, identifiedBy, field,
} from './base';

import { action, computed, observable } from 'mobx';
import UiSettings from 'shared/src/model/ui-settings';
import Courses from './courses-map';

@identifiedBy('user')
export class User extends BaseModel {

  @action.bound
  bootstrap(data) {
    this.update(data);
  }

  @observable csrf_token;

  @field name;
  @field self_reported_role;
  @field account_uuid;

  @field faculty_status;
  @field profile_url;

  @field is_admin;
  @field is_content_analyst;
  @field is_customer_service;

  @field({ type: 'array' }) viewed_tour_ids;

  @computed get isConfirmedFaculty() {
    return this.faculty_status === 'confirmed_faculty';
  }

  @computed get tourAudienceTags() {
    if (Courses.active.teaching.nonPreview.any) { return ['teacher']; }
    if (Courses.active.teaching.any) { return ['teacher-preview']; }
    return [];
  }

  replayTour(tour) {
    this.viewed_tour_ids.remove(tour.id);
  }

  viewedTour(tour, options) {
    this.viewed_tour_ids.push(tour.id);
    this.saveTourView(tour, options);
  }

  verifiedRoleForCourse(course) {
    return course.primaryRole && this.isConfirmedFaculty ? course.primaryRole.type : 'student';
  }

  saveTourView(tour, options) {
    return { data: options };
  }

  @computed get isUnverifiedInstructor() {
    return !this.isConfirmedFaculty && this.self_reported_role === 'instructor';
  }

  recordSessionStart() {
    UiSettings.set('sessionCount', this.sessionCount + 1);
  }

  get sessionCount() {
    return UiSettings.get('sessionCount') || 0;
  }

  logEvent({ category, code, data }) {
    // students do not track events
    if (!this.isConfirmedFaculty && this.self_reported_role === 'student') { return 'ABORT'; }
    return { category, code, data };
  }

}

const currentUser = new User;

window.currentUser = currentUser;

export default currentUser;
