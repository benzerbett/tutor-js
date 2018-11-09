React = require 'react'
ReactDOM  = require 'react-dom'
{SpyMode, ArbitraryHtmlAndMath, GetPositionMixin} = require 'shared'
{observer} = require 'mobx-react'
classnames = require 'classnames'

{BookContentMixin} = require './book-content-mixin'

{ReferenceBookExerciseShell} = require './book-page/exercise'
RelatedContent = require './related-content'
{default: Loading} = require './loading-screen'

Router = require '../helpers/router'
Dialog = require './dialog'
{default: AnnotationWidget} = require './annotations/annotation'
{ ReferenceBookExerciseActions, ReferenceBookExerciseStore } = require '../flux/reference-book-exercise'
map = require 'lodash/map'
forEach = require 'lodash/forEach'

BookPage = React.createClass
  displayName: 'BookPage'

  propTypes:
    ux: React.PropTypes.object.isRequired

  mixins: [BookContentMixin, GetPositionMixin]

  getCnxId: ->
    this.props.ux.page.cnx_id

  componentWillMount: ->
    this.props.ux.page.ensureLoaded()

  componentWillReceiveProps: (nextProps) ->
    @props.ux.page.ensureLoaded()

  getSplashTitle: ->
    this.props.ux.page.title

  componentDidMount: ->
    this.props.ux.checkForTeacherContent()

  componentDidUpdate: ->
    this.props.ux.checkForTeacherContent()

  # used by BookContentMixin
  shouldOpenNewTab: -> true

  waitToScrollToSelector: (hash) ->
    images = ReactDOM.findDOMNode(@).querySelectorAll('img')
    imagesToLoad = images.length
    onImageLoad = =>
      imagesToLoad -= 1
      if imagesToLoad is 0
        # final scroll to
        @scrollToSelector(hash)
    for image in images
      image.addEventListener('load', onImageLoad)

    images.length > 0

  renderExercises: (exerciseLinks) ->
    ReferenceBookExerciseStore.setMaxListeners(exerciseLinks.length)
    links = map(exerciseLinks, 'href')
    ReferenceBookExerciseActions.loadMultiple(links) unless ReferenceBookExerciseStore.isLoaded(links)

    forEach(exerciseLinks, @renderExercise)

  renderExercise: (link) ->
    exerciseAPIUrl = link.href
    exerciseNode = link.parentNode.parentNode
    ReactDOM.render(<ReferenceBookExerciseShell exerciseAPIUrl={exerciseAPIUrl}/>, exerciseNode) if exerciseNode?

  render: ->
    { ux, ux: { page } } = @props

    if not page or page.api.isPending
      if ux.lastSection
        isLoading = true
        page = ux.pages.byChapterSection.get(ux.lastSection)
      else
        return <Loading />


    related =
      chapter_section: page.chapter_section.asArray
      title: @getSplashTitle()

    <div
      className={
        classnames('book-page', @props.className, {
          'page-loading loadable is-loading': isLoading,
          'book-is-collated': page.bookIsCollated,
          })
      }
      {...ux.courseDataProps}
    >
      {@props.children}
      <div className='page center-panel'>
        <RelatedContent
          contentId={page.cnx_id} {...related}
        />
        <ArbitraryHtmlAndMath className='book-content' block html={page.contents} />
      </div>

      <SpyMode.Content className="ecosystem-info">
        PageId: {page.cnx_id}, Ecosystem: {JSON.stringify(page?.spy)}
      </SpyMode.Content>

      {ux.allowsAnnotating and (
        <AnnotationWidget
          courseId={ux.course.id}
          chapter={page.chapter_section.chapter}
          section={page.chapter_section.section}
          title={related.title}
          documentId={page.cnx_id}
        />
      )}
    </div>

module.exports = observer(BookPage)
