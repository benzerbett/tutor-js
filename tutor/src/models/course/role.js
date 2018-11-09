import {
  BaseModel, identifiedBy, field, identifier,
} from 'shared/model';
import { computed } from 'mobx';
import moment from 'moment';
import { TimeStore } from '../../flux/time';

export default
@identifiedBy('course/role')
class CourseRole extends BaseModel {
  @identifier id;

  @field({ type: 'date' }) joined_at;
  @field type;
  @field research_identifier;

  @computed get isStudent() {
    return this.type == 'student';
  }

  @computed get isTeacher() {
    return this.type == 'teacher';
  }

  joinedAgo(terms = 'days') {
    return moment(TimeStore.getNow()).diff(this.joined_at, terms);
  }
};
