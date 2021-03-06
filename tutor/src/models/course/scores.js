import { find } from 'lodash';
import { observable, action } from 'mobx';
import Map from 'shared/model/map';

import {
  BaseModel, identifiedBy, belongsTo,
} from 'shared/model';

import ScoresForPeriod from './scores/period';

export default
@identifiedBy('course/scores')
class CourseScores extends BaseModel {

  @belongsTo({ model: 'course' }) course;

  @observable periods = new Map();

  fetch() {
    return { courseId: this.course.id };
  }

  @action onFetchComplete({ data }) {
    data.forEach(s => this.periods.set(s.period_id, new ScoresForPeriod(s, this.course)));
  }

  getTask(taskId) {
    const id = Number(taskId);
    const periods = this.periods.values();
    for(let p=0; p < periods.length; p+=1) {
      const period = periods[p];
      for(let i=0; i < period.students.length; i +=1 ){
        const task = find(period.students[i].data, { id });
        if (task) return task;
      }
    }
    return null;
  }

};
