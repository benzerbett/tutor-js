import {BaseModel, identifiedBy, action, observable} from 'shared/model'

@identifiedBy('favorite')
export default class Favorite extends BaseModel {
  constructor() {
    super()
  }

  add(id) { return({data: {publication: id}}); }
  onCreated({data}) {
    console.log(data)
  }
}