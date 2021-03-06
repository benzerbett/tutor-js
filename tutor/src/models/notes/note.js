import { isString } from 'lodash';
import { computed, action, intercept } from 'mobx';
import { SerializedHighlight } from '@openstax/highlighter';
import {
  BaseModel, identifiedBy, field, identifier,
} from 'shared/model';


@identifiedBy('notes/note')
export default class Note extends BaseModel {

  static MAX_TEXT_LENGTH = 500;
  @identifier id;
  @field chapter;
  @field content;
  @field courseId;
  @field section;
  @field title;
  @field text;
  @field type;
  @field({ type: 'object' }) rect;
  highlight;
  listing;

  constructor(attrs) {
    super(attrs);
    this.highlight = new SerializedHighlight(attrs);
    this.listing = attrs.listing;
    intercept(this, 'text', this.validateTextLength);
  }

  validateTextLength(change) {
    if (isString(change.newValue) && change.newValue.length > Note.MAX_TEXT_LEN) {
      change.newValue = change.newValue.slice(0, Note.MAX_TEXT_LEN);
    }
    return change;
  }

  @computed get chapter_section() {
    return [ this.chapter, this.section ];
  }

  @computed get formattedChapterSection() {
    let cs = `${this.chapter}`;
    if (this.section) { cs += `.${this.section}`; }
    return cs;
  }

  @action save() {
    return this.listing.update(this);
  }

  @action destroy() {
    return this.listing.destroy(this);
  }
}
