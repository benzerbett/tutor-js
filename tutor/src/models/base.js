// will eventually hook into data loading/saving using the
// derived model's identifiedBy strings

import { observable, computed, action } from 'mobx';
import { find, isNil, get } from 'lodash';
import { nonenumerable } from 'core-decorators';

  const FLUX_NEW = /_CREATING_/;

export class BaseModel {

  constructor(attrs) {
    if (attrs) { this.update(attrs); }
  }

  @nonenumerable apiRequestsInProgress = observable.map();
  @nonenumerable apiErrors;

  @computed get hasApiRequestPending() {
    return !!this.apiRequestsInProgress.size;
  }

  @computed get isNew() {
    const idField = find(Array.from(this.constructor.$schema.values()), { type: 'identifier' });
    const id = this[idField.name];
    return isNil(id) || FLUX_NEW.test(id);
  }

  @action
  loaded(req) {
    this.update(req.data);
  }

  @action
  onApiRequestComplete({ data }) {
    this.update(data);
  }

  @action
  setApiErrors(error) {
    const errors = get(error, 'response.data.errors');
    if (errors) {
      this.apiErrors = {};
      errors.forEach(e => this.apiErrors[e.code] = e);
      error.isRecorded = true;
    } else {
      this.apiErrors = null;
    }
  }

}

// export decorators so they can be easily imported into model classes
export {
  identifiedBy, identifier, hasMany, belongsTo, field, session,
} from 'mobx-decorated-models';

export {
  computed,
  observable,
} from 'mobx';
