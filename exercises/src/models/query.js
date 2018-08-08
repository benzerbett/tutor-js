import { map } from 'lodash';
import lazyGetter from 'shared/helpers/lazy-getter';
import {
  BaseModel, identifiedBy, belongsTo, identifier, field, hasMany, observable, computed, action,
} from 'shared/model';

import Exercise from 'shared/model/exercise';

@identifiedBy('query')
export default class Query extends BaseModel {
  @hasMany({ model: Exercise }) exercises;
  @observable total_count;

  perform(filter, value) {
    return({query: {
      q: `${filter}:"${value}"`
    }});
  }

  onComplete({ data: { total_count, items } }) {
    this.total_count = total_count;
    this.exercises = items;
  }
}
