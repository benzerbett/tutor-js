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

  toggleExpand: ->
    @setState({expanded: !@state.expanded})

  onClick: ->
    @context.router.transitionTo 'viewTaskStep',
      # url is 1 based so it matches the breadcrumb button numbers. 1==first step
      {courseId:@props.courseId, id: @props.post.id, stepIndex: 1}

  hideTask: ->
    StudentDashboardActions.hide(@props.post.id)
    StudentDashboardStore.on('hidden', @hidden)

  hidden: -> @setState({hidden: true})

  renderComments: (comment) ->
    <BS.Row className="comment-data">
      <BS.Col xs={9} sm={9} xsOffset={2} smOffset={2} className='comment'>
        <span className="comment-author">{comment.author}:</span>
        <span className="comment-text">{comment.text}</span>
      </BS.Col>
    </BS.Row>

  renderExpansion: ->
    className = "post-data"
    if @state.expanded
      className += " expanded"
    <div className={className}>
      <BS.Row className="post-text">
        <BS.Col xs={10} sm={10} xsOffset={1} smOffset={1} className='post-text'>
          {@props.post.text}
        </BS.Col>
      </BS.Row>

      {_.map(@props.post.comments, @renderComments)}
      
      <BS.Row className="comment-form">
        <BS.Col xs={9} sm={9} xsOffset={2} smOffset={2} className="comment-box">
          <form>
            <input type="text" class="form-control" id="comment-input" placeholder="Add Comment...">
            </input>
          </form>
        </BS.Col>
      </BS.Row>

    </div>

  render: ->

    if @state.hidden then return null

    deleted = StudentDashboardStore.isDeleted(@props.post)
    classes = classnames("post row #{@props.className}", {deleted})

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

    <div className={classes} onClick={@toggleExpand}
      data-event-id={@props.post.id}>
      <BS.Row className="post-header">
        <BS.Col xs={2}  sm={1} className={"column-icon"}>
          <i className={"icon icon-lg icon-#{@props.className}"}/>
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
