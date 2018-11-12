import { readonly } from 'core-decorators';
import { merge, extend, defer, last, get, pick } from 'lodash';
import htmlparser from 'htmlparser2';
import { action, observable, when,computed } from 'mobx';
import {
  BaseModel, identifiedBy, belongsTo, identifier, field, session, hasMany,
} from 'shared/model';
import ChapterSection from '../chapter-section';
import { StepTitleActions } from '../../flux/step-title';
import { MediaActions } from '../../flux/media';
import Exercises from '../exercises';

const UPDATEABLE_FIELDS = ['content_html', 'spy'];

export default
@identifiedBy('reference-book/page')
class ReferenceBookPage extends BaseModel {
  @identifier id;
  @field title;
  @field type;
  @field cnx_id;
  @field short_id;
  @field uuid;
  @field({ model: ChapterSection }) chapter_section;
  @session chapter;
  @readonly depth = 2;
  @field content_html = '';
  @readonly isPage = true;

  // nb these are not observable, othewise they can't be set from within mapPages computed
  nextPage = null;
  prevPage = null;

  @action linkNextPage(pg) {
    this.nextPage = pg;
    pg.prevPage = this;
    return pg;
  }

  //
  @action fetchExercises() {
  }

  @action ensureLoaded() {
    if (!this.api.isPending && !this.api.hasBeenFetched) { this.fetchContent(); }
  }

  @computed get contents() {
    // FIXME the BE sends HTML with head and body
    // Fixing it with nasty regex for now
    return this.content_html
      .replace(/^[\s\S]*<body[\s\S]*?>/, '')
      .replace(/<\/body>[\s\S]*$/, '');
  }

  fetchContent() { }

  @action onContentFetchComplete({ data }) {
    this.update(pick(data, UPDATEABLE_FIELDS));
    MediaActions.parse(this.content_html);
    StepTitleActions.parseMetaOnly(this.cnx_id, this.content_html);
  }

  @computed get asTopic() {
    return merge({ chapter_section: this.chapter_section.asString }, pick(this, 'id', 'title'));
  }

  @computed get bookIsCollated() {
    return get(this, 'chapter.book.is_collated', false);
  }

}

// a mock page for use by entities such as exercises that need to indicate
// they are not linked to a "real" page
ReferenceBookPage.UNKNOWN = new ReferenceBookPage({ id: 'UNKNOWN', chapter_section: ['99','99'] });
