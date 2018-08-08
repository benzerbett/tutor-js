import {BaseModel, identifiedBy, action, observable} from 'shared/model'

@identifiedBy('user')
export default class User extends BaseModel {
  @observable username = ''
  
  getUsername() {
    return this.username;
  }
  fetch() { return {} }
  onComplete({data}) {
    this.username = data.username
  }
}