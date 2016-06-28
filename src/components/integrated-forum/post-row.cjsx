React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
{StudentDashboardStore, StudentDashboardActions} = require '../../flux/student-dashboard'
EventInfoIcon = require '../student-dashboard/event-info-icon'
{Instructions} = require '../task/details'
classnames = require 'classnames'
_ = require 'underscore'

module.exports = React.createClass
  displayName: 'PostRow'

  propTypes:
    className: React.PropTypes.string.isRequired
    post:     React.PropTypes.object.isRequired
    courseId:  React.PropTypes.string.isRequired
    feedback:  React.PropTypes.string.isRequired

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    hidden: false
    expanded: false

  expand: ->
    if !@state.expanded
      @setState({expanded: true})

  retract: ->
    if @state.expanded
      @setState({expanded: false})

  autoGrow: (event) ->
    event.target.style.height = "5px"
    event.target.style.height = (event.target.scrollHeight)+"px"

  hideTask: ->
    StudentDashboardActions.hide(@props.post.id)
    StudentDashboardStore.on('hidden', @hidden)

  hidden: -> @setState({hidden: true})

  renderComments: (comment) ->
    <BS.Row className="comment-row">
      <BS.Col xs={9} sm={9} xsOffset={2} smOffset={2} className='comment'>
        <span className="comment-author">{comment.author}:</span>
        <span className="comment-text">{comment.text}</span>
      </BS.Col>
    </BS.Row>

  renderExpansion: ->
    <div className="post-data">
      <BS.Row className="post-text-row">
        <BS.Col xs={10} sm={10} xsOffset={1} smOffset={1} className='post-text'>
          {@props.post.text}
        </BS.Col>
      </BS.Row>

      {_.map(@props.post.comments, @renderComments)}

      <BS.Row className="comment-form">
        <BS.Col xs={8} sm={8} xsOffset={2} smOffset={2} className="comment-box">
          <form>
            <textarea class="form-control" id="comment-input" placeholder="Add Comment..." onChange={@autoGrow}>
            </textarea>
          </form>
        </BS.Col>
        <BS.Col xs={1} sm={1} className="comment-submit">
          <BS.Button bsStyle="primary" className="comment-submit-button">Submit</BS.Button>
        </BS.Col>
      </BS.Row>
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

    deleted = StudentDashboardStore.isDeleted(@props.post)
    classes = classnames("post row #{@props.className}", {deleted})

    if @state.expanded
      classes += " expanded"

    if deleted
      hideButton = <BS.Button className="-hide-button" onClick={@hideTask}>
        <i className="fa fa-close"/>
      </BS.Button>
      feedback = <span>Withdrawn</span>
    else
      postDate = <Time date={@props.post.postDate} format='concise'/>
      feedback = [
        <span>{@props.feedback}</span>
        <EventInfoIcon event={@props.post} />
      ]

    <div className={classes} onClick={@expand}>
      <BS.Row className="post-header">
        <BS.Col xs={2}  sm={1} className={"column-icon"}>
          <i className={"icon icon-lg icon-check"}/>
        </BS.Col>
        <BS.Col xs={10} sm={6} className='title'>
          {@props.children}
        </BS.Col>
        <BS.Col xs={5}  sm={3} className='author'>
          {@props.post.author}
        </BS.Col>
        <BS.Col xs={5}  sm={2} className='post-date'>
          {postDate}
        </BS.Col>
      </BS.Row>
      {@renderExpansion()}
    </div>
