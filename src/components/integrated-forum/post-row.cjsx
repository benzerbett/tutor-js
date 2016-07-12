React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
moment = require 'moment'
classnames = require 'classnames'
_ = require 'underscore'
{ForumActions, ForumStore} = require '../../flux/forum'
{TimeStore} = require '../../flux/time'
moment = require 'moment-timezone'


module.exports = React.createClass
  displayName: 'PostRow'

  propTypes:
    className: React.PropTypes.string.isRequired
    post:     React.PropTypes.object.isRequired
    courseId:  React.PropTypes.string.isRequired

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    hidden: false
    expanded: false
    comment: ''

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

  autoGrow: (event) ->
    @setState({comment: event.target.value})
    event.target.style.height = "5px"
    event.target.style.height = (event.target.scrollHeight)+"px"

  hidden: ->
    @setState({hidden: true})

  renderComments: (comment) ->
    cPostDate = <Time date={comment.post_date} format='concise'/>

    <BS.Row className="comment-row">
      <BS.Col xs={2} sm={2} className="reply-prompt-col">
        <span className="reply-prompt">{"Reply to"}</span>
      </BS.Col>
      <BS.Col xs={7} sm={7} className='comment'>
        <span className="comment-author">{comment.author}{": "}</span>
        <span className="comment-text">{comment.text}</span>
      </BS.Col>
      <BS.Col xs={2} sm={2} className="comment-post-date">
        {cPostDate}
      </BS.Col>
    </BS.Row>


  handleSubmit: (submitEvent) ->
    submitEvent.preventDefault()
    comment = @state.comment.trim().replace(/\n\s*\n/g, '\n')
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
      @setState({comment:''})
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
      {_.map(@props.post.comments, @renderComments)}
      {if @state.commentLengthAlert
        <BS.Row>
          <BS.Col xs={9} sm={9} xsOffset={2} smOffset={2} className="comment-alert-col">
            <BS.Alert className="comment-alert" bsStyle="warning">
              {"Your comment must be between 2 and 5000 characters!"}
            </BS.Alert>
          </BS.Col>
        </BS.Row>
      }
      <form onSubmit={@handleSubmit}>
        <BS.Row className="comment-form">
          <BS.Col xs={7} sm={7} xsOffset={2} smOffset={2} className="comment-box">
              <textarea
                className="comment-input"
                placeholder="Add Comment..."
                value={@state.comment}
                onChange={@autoGrow}>
              </textarea>
          </BS.Col>
          <BS.Col xs={2} sm={2} className="comment-submit">
            <BS.Button type="submit" bsStyle="primary" className="comment-submit-button">Comment</BS.Button>
          </BS.Col>
        </BS.Row>
      </form>
      <BS.Row className="retract-row">
        <BS.Col xs={10} sm={10} xsOffset={1} smOffset={1} className="retract">
          <div className="retract-button" onClick={@retract}>
            {'Show less \u25B2'}
          </div>
        </BS.Col>
      </BS.Row>
    </div>

  render: ->

    if @state.hidden then return null

    classes = classnames("post row #{@props.className}")

    if @state.expanded
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
        </BS.Col>
      </BS.Row>
      {@renderExpansion()}
    </div>
