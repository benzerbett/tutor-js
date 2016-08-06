React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
classnames = require 'classnames'
_ = require 'underscore'
{ForumActions, ForumStore} = require '../../flux/forum'
{TimeStore} = require '../../flux/time'
moment = require 'moment-timezone'
TeacherComment = require './teacher-comment'
CommentSubmitForm = require './comment-submit-form'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'


module.exports = React.createClass
  displayName: 'TeacherPostRow'

  propTypes:
    className: React.PropTypes.string.isRequired
    post:     React.PropTypes.object.isRequired
    courseId:  React.PropTypes.string.isRequired

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    expanded: false
    commentLengthAlert: false
    tag: ''
    deleted: false
    showDeleteModal: false

  closeDeleteModal: ->
    @setState({showDeleteModal:false})

  openDeleteModal: ->
    if @state.expanded
      @setState({showDeleteModal:true})

  deleteOperations: ->
    @setState({showDeleteModal:false})
    @setState({deleted: true})

  confirmDeletion: ->
    @props.confirmDeletion(@props.comment)

  expand: ->
    if !@state.expanded
      @setState({expanded: true})

  retract: ->
    if @state.expanded
      @setState({expanded: false})

  showLengthAlert: ->
    @setState({commentLengthAlert: true})

  hideLengthAlert: ->
    @setState({commentLengthAlert: false})

  addReplyTag: (author) ->
    tagConcat = '@' + author + ': '
    @setState({tag: tagConcat})

  renderComment: (comment) ->
    <TeacherComment post={@props.post} comment={comment} onClick={_.partial(@addReplyTag, comment.author)} />

  handleSubmit: (submitEvent, comment) ->
    submitEvent.preventDefault()
    comment = comment.trim().replace(/\n\s*\n/g, '\n')
    postid = @props.post.id
    #dateTime = moment().format('YYYY-MM-DDTh:mm:ss.SSSZ')
    length = comment.length

    if length > 1 and length < 5001
      ForumActions.save(@props.courseId,{
          type: 'comment',
          postid: postid,
          text: comment,
          postDate: moment(TimeStore.getNow()).format('YYYY-MM-DDTh:mm:ss.SSS')+"Z"
        }
      )
      @setState({tag:''})
      @hideLengthAlert()
    else
      @showLengthAlert()

  renderTag: (tag) ->
    <BS.Label>{tag}</BS.Label>

  renderExpansion: ->
    postText = @props.post.text.trim().replace(/\n\s*\n/g, '\n')
    <div className="post-data">
      <BS.Row className="post-text-row">
        <BS.Col xs={10} sm={10} xsOffset={1} smOffset={1} className='post-text'>
          {postText}
        </BS.Col>
      </BS.Row>
      <BS.Row className="tag-row">
        <BS.Col xs={10} sm={10} xsOffset={1} smOffset={1} className="tags">
          {_.map(@props.post.tags, @renderTag)}
        </BS.Col>
      </BS.Row>
      {_.map(@props.post.comments, @renderComment)}
      {if @state.commentLengthAlert
        <BS.Row>
          <BS.Col xs={9} sm={9} xsOffset={2} smOffset={2} className="comment-alert-col">
            <BS.Alert className="comment-alert" bsStyle="warning">
              {"Your comment must be between 2 and 5000 characters!"}
            </BS.Alert>
          </BS.Col>
        </BS.Row>
      }
      <CommentSubmitForm handleSubmit={@handleSubmit} ref='commentForm' tag={@state.tag}/>
      <BS.Row className="retract-row">
        <BS.Col xs={10} sm={10} xsOffset={1} smOffset={1} className="retract">
          <div className="retract-button" onClick={@retract}>
            {'Show less \u25B2'}
          </div>
        </BS.Col>
      </BS.Row>
    </div>

  render: ->

    tooltipClass = ""
    if !@state.expanded
      tooltipClass = "hidden"

    tooltipDelete = <BS.Tooltip id="delete-tooltip" className={tooltipClass}>Delete Post</BS.Tooltip>
    classes = classnames("post row #{@props.className}")

    if @state.deleted
      classes += " deleted"
    else if @state.expanded
      classes += " expanded"

    postDate = <Time date={@props.post.post_date} format='concise'/>

    <div className={classes} onClick={@expand}>
      <BS.Row className="post-header">
        <BS.Col xs={2}  sm={1} className={"column-icon"}>
          <i className={"icon icon-lg icon-#{@props.className}"}/>
        </BS.Col>
        <BS.Col xs={10} sm={6} className='title'>
          {@props.children}
        </BS.Col>
        <BS.Col xs={8} sm={5} className='post-info'>
          <span className="post-author-label">{"Posted by "}</span>
          <span className="post-author">{@props.post.author}</span>
          <span className="post-date-label">{" | "}</span>
          <span className="post-date">{postDate}</span>
          <div className="icon-delete-container" onClick={@openDeleteModal}>
            <BS.OverlayTrigger placement="top" overlay={tooltipDelete}>
              <i className="icon icon-delete"/>
            </BS.OverlayTrigger>
          </div>
          <BS.Modal className="delete-confirm-modal" show={@state.showDeleteModal} onHide={@closeDeleteModal}>
            <ModalHeader closeButton className="delete-confirm-header">
              <BS.Modal.Title>{"Confirm Deletion"}</BS.Modal.Title>
            </ModalHeader>
            <BS.Modal.Body className="delete-confirm-body">
              <BS.Row>
                <span>
                  {"Are you sure you want to delete this post?"}
                </span>
              </BS.Row>
            </BS.Modal.Body>
            <BS.Modal.Footer className="delete-confirm-footer">
              <BS.Button bsStyle="default" onClick={@closeDeleteModal}>
                {"Cancel"}
              </BS.Button>
              <BS.Button bsStyle="primary" onClick={@deleteOperations}>
                {"Confirm"}
              </BS.Button>
            </BS.Modal.Footer>
          </BS.Modal>
        </BS.Col>
      </BS.Row>
      {@renderExpansion()}
    </div>
