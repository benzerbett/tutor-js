import { React, PropTypes, observer, cn } from '../helpers/react';
import { observable, action, computed, when } from 'mobx';
import { autobind } from 'core-decorators';
import { Icon, Logging } from 'shared';
import User from '../models/user';
import { filter, last, sortBy } from 'lodash';
import SummaryPage from './notes/summary-page';
import dom from '../helpers/dom';
import imagesComplete from '../helpers/images-complete';
import Courses from '../models/courses-map';
import EditBox from './notes/edit-box';
import SidebarButtons from './notes/sidebar-buttons';
import InlineControls from './notes/inline-controls';
import ScrollTo from '../helpers/scroll-to';
import Highlighter from '@openstax/highlighter';
import Router from '../helpers/router';
import NotesMap from '../models/notes';
import Overlay from './obscured-page/overlay';

export default
@observer
class NotesWidget extends React.Component {

  static propTypes = {
    courseId: PropTypes.string.isRequired,
    documentId: PropTypes.string,
    windowImpl: PropTypes.shape({
      open: PropTypes.func,
    }),
    title: PropTypes.string,
    chapter: PropTypes.number.isRequired,
    section: PropTypes.number.isRequired,
    notes: PropTypes.instanceOf(NotesMap),
  };

  static defaultProps = {
    notes: User.notes,
    windowImpl: window,
  };

  scrollHelper = new ScrollTo({ windowImpl: this.props.windowImpl, scrollingTargetClass: false });
  highlightScrollHandler = elements => this.scrollHelper.scrollToElement(last(elements), {
    scrollTopOffset: (window.innerHeight / 2) - 80,
  });

  @observable scrollToPendingNote;
  @observable highlighter;
  @observable referenceElements = [];
  @observable activeNote;
  @observable pendingHighlight;

  componentDidMount() {
    if (!this.course.canAnnotate) { return; }

    const { highlight } = Router.currentQuery();

    if (highlight) {
      this.setupPendingHighlightScroll(highlight);
    }

    when(
      () => !this.props.notes.api.isPending,
      () => this.initializePage(),
    );
  }

  componentWillReceiveProps() {
    if (!this.course.canAnnotate) { return; }
    this.activeNote = null;
    this.initializePage();
  }

  componentWillUnmount() {
    if (this.highlighter) {
      this.highlighter.unmount();
    }
  }

  @computed get course() {
    return Courses.get(this.props.courseId);
  }

  @computed get notesForThisPage() {
    return this.allNotesForThisBook.filter(item =>
      (item.chapter === this.props.chapter) &&
      (item.section === this.props.section) &&
      this.highlighter &&
      item.highlight.isLoadable(this.highlighter)
    );
  }

  @computed get allNotesForThisBook() {
    return filter(this.props.notes.array, { courseId: this.props.courseId });
  }

  setupPendingHighlightScroll(highlightId) {
    this.scrollToPendingNote = () => {
      const highlight = this.highlighter.getHighlight(highlightId);

      this.highlighter.clearFocus();
      if (highlight) {
        highlight.focus().scrollTo(this.highlightScrollHandler);
      } else {
        Logging.error(`Page attempted to scroll to note id '${highlightId}' but it was not found`);
      }
      this.scrollToPendingNote = null;
    };
  }

  waitForPageReady() {
    return new Promise(resolve => {
      const win = this.props.windowImpl;
      const unprocessedMath = !!win.document.querySelector('.book-content *:not(.MJX_Assistive_MathML) > math');
      const runImagesComplete = () => imagesComplete({
        body: win.document.querySelector('.book-content'),
      })
        .finally(resolve)
      ;

      if (win.MathJax && unprocessedMath) {
        win.MathJax.Hub.Register.MessageHook('End Process', runImagesComplete);
      } else {
        runImagesComplete();
      }
    });
  }

  getBookContentRef() {
    return this.props.windowImpl.document.querySelector('.book-content');
  }

  initializePage() {
    this.ux.statusMessage.show({
      type: 'info',
      message: 'Waiting for page to finish loading…',
    });

    this.getReferenceElements();
    if (!this.referenceElements.length) { return Promise.resolve(); }

    const initialize = action(() => {
      // remove any existing highlighter
      if (this.highlighter) {
        this.highlighter.unmount();
      }
      // create a new highlighter
      this.highlighter = new Highlighter(this.getBookContentRef(), {
        snapTableRows: true,
        snapMathJax: true,
        snapWords: true,
        className: 'tutor-highlight',
        onClick: this.onHighlightClick,
        onSelect: this.onHighlightSelect,
      });
      // attach notes to highlghter
      this.notesForThisPage.forEach(note => this.highlighter.highlight(note.highlight));
      // scroll if needed
      if (this.scrollToPendingNote) {
        this.scrollToPendingNote();
      }
      // and we're done
      this.ux.statusMessage.hide();
    });

    return this.waitForPageReady().then(initialize);
  }

  @action.bound onHighlightClick(highlight) {
    const note = highlight ? this.props.notes.get(highlight.id) : null;
    this.pendingHighlight = null;
    this.activeNote = note;

    this.highlighter.clearFocus();
    if (highlight) {
      highlight.focus().scrollTo(this.highlightScrollHandler);
    }
  }

  cantHighlightReason(highlights, highlight) {
    if (highlights.length > 0) {
      return 'Highlights cannot overlap one another';
    }
    const node = dom(highlight.range.commonAncestorContainer);

    if (!node.closest('.book-content')) {
      return 'Only content can be highlighted';
    }

    for (const re of this.referenceElements) {
      if (dom(re).isParent(node.el)) {
        return null;
      }
    }

    return 'Only content that is enclosed in paragraphs can be highlighted';
  }

  @action.bound onHighlightSelect(highlights, highlight) {
    this.activeNote = null;
    const error = this.cantHighlightReason(highlights, highlight);

    if (error) {
      this.pendingHighlight = null;
      this.ux.statusMessage.show({ message: error, autoHide: true });
    } else {
      this.pendingHighlight = highlight;
      this.ux.statusMessage.hide();
    }
  }

  @action
  getReferenceElements() {
    this.referenceElements = Array.from(
      this.props.windowImpl.document.querySelectorAll('.book-content > [id]')
    ).reverse();
  }

  @autobind
  highlightAndClose() {
    return this.saveNewHighlight().then(
      action(note => {
        this.props.windowImpl.getSelection().removeAllRanges();
        this.pendingHighlight = null;
        this.highlighter.highlight(note.highlight);
        return note;
      }));
  }

  @autobind
  openAnnotator() {
    return this.highlightAndClose().then(note => this.activeNote = note);
  }

  @autobind
  saveNewHighlight() {
    const highlight = this.pendingHighlight;

    const referenceElement = this.referenceElements
      .find(re => dom(re).isParent(highlight.range.commonAncestorContainer));

    const serializedHighlight = highlight.serialize(referenceElement);

    return this.props.notes.create({
      research_identifier: this.course.primaryRole.research_identifier,
      userRole: this.course.primaryRole.type,
      documentId: this.props.documentId,
      courseId: this.props.courseId,
      chapter: this.props.chapter,
      section: this.props.section,
      title: this.props.title,
      rect: dom(highlight.range).boundingClientRect,
      ...serializedHighlight.data,
    });
  }

  @computed get sortedNotesForPage() {
    return sortBy(
      this.notesForThisPage,
      ['selection.bounds.top', 'selection.start']
    );
  }

  getNoteByOffset(offset) {
    const note = this.activeNote;
    if (!note) {
      return null;
    }
    const highlight = this.highlighter.getHighlight(note.id);
    if (!highlight) {
      return null;
    }

    const highlights = this.highlighter.getHighlights();
    const targetIndex = highlights.indexOf(highlight) + offset;

    if (!highlights[targetIndex]) {
      return null;
    }

    const targetNoteId = highlights[targetIndex].id;

    return this.props.notes.get(targetNoteId);
  }

  get nextNote() {
    return this.getNoteByOffset(1);
  }

  get previousNote() {
    return this.getNoteByOffset(-1);
  }

  @action.bound setElement(el) {
    this.element = el;
  }

  get parentRect() {
    if (!this.element) {
      return { top: 0, bottom: 0, left: 0, right: 0 };
    }
    const wLeft = this.props.windowImpl.pageXOffset;
    const wTop = this.props.windowImpl.pageYOffset;
    const parentRect =  this.element.parentElement.getBoundingClientRect();
    return {
      bottom: wTop + parentRect.bottom,
      left: wLeft + parentRect.left,
      right: wLeft + parentRect.right,
      top: wTop + parentRect.top,
    };
  }

  @computed get ux() { return this.props.notes.ux; }

  @action.bound seeAll() {
    this.ux.isSummaryVisible = true;
    this.activeNote = null;
  }

  @action.bound editNote(note) {
    this.activeNote = note;

    this.highlighter.clearFocus();
    const highlight = this.highlighter.getHighlight(note.id);
    if (highlight) {
      highlight.focus().scrollTo(this.highlightScrollHandler);
    }
  }

  @action.bound hideActiveHighlight() {
    this.activeNote = null;
  }

  @action.bound onNoteDelete(note) {
    const highlight = this.highlighter.getHighlight(note.id);
    if (highlight) {
      this.highlighter.erase(highlight);
    }
  }

  renderStatusMessage() {
    if (!this.ux.statusMessage.display) { return null; }

    return (
      <div
        className={cn('status-message-toast', this.ux.statusMessage.type)}
      >
        <Icon type={this.ux.statusMessage.icon} /> {this.ux.statusMessage.message}
      </div>
    );
  }

  render() {
    if (!this.course.canAnnotate) { return null; }

    return (
      <div className="annotater" ref={this.setElement}>
        <InlineControls
          pendingHighlight={this.pendingHighlight}
          windowImpl={this.props.windowImpl}
          parentRect={this.parentRect}
          annotate={this.openAnnotator}
          highlight={this.highlightAndClose}
        />
        <EditBox
          note={this.activeNote}
          onHide={this.hideActiveHighlight}
          onDelete={this.onNoteDelete}
          goToNote={this.editNote}
          next={this.nextNote}
          previous={this.previousNote}
          seeAll={this.seeAll}
        />
        <SidebarButtons
          windowImpl={this.props.windowImpl}
          highlighter={this.highlighter}
          notes={this.notesForThisPage}
          parentRect={this.parentRect}
          onClick={this.editNote}
          activeNote={this.activeNote}
        />
        {this.renderStatusMessage()}
        <Overlay
          id="notes-summary"
          visible={this.ux.isSummaryVisible}
          onHide={this.ux.hideSummary}
          renderer={() => (
            <SummaryPage
              courseId={this.props.courseId}
              notes={this.props.notes}
              onDelete={this.onNoteDelete}
              currentChapter={this.props.chapter}
              currentSection={this.props.section}
            />
          )}
        />
      </div>
    );
  }

};
