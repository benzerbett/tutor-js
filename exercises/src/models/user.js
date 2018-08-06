import {BaseModel, identifiedBy, action, observable} from 'shared/model'

@identifiedBy('user')
export default class User extends BaseModel {
  @observable username = ''

  constructor() {
    super()
  }

  getUsername() {
    console.log("Fetching username")
    console.log(this.username)
    return this.username;
  }
  fetch() { return {} }
  onComplete({data}) {
    console.log("Fetch complete")
    this.username = data.username
    console.log(this.username)
  }
}