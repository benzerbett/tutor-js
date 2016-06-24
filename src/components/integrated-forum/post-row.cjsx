React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
{StudentDashboardStore, StudentDashboardActions} = require '../../flux/student-dashboard'
EventInfoIcon = require '../student-dashboard/event-info-icon'
{Instructions} = require '../task/details'
classnames = require 'classnames'

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

  renderExpansion: ->
    if !@state.expanded then return null

    <BS.Row>
      <BS.Col xs={20} sm={8} xsOffset={2} className='text'>
        {@props.post.text}
      </BS.Col>
    </BS.Row>

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
      <BS.Row>
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
