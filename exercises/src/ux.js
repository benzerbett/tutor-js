import lazyGetter from 'shared/helpers/lazy-getter';
import {
  BaseModel, identifiedBy, belongsTo, identifier, field, hasMany, observable, computed, action,
} from 'shared/model';

import Search from './models/search';
import User from './models/user'

export default class ExerciseUX {

  @lazyGetter search = new Search();
  @lazyGetter user = new User();
}
