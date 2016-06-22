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

  getInitialState: -> hidden: false

  onClick: ->
    @context.router.transitionTo 'viewTaskStep',
      # url is 1 based so it matches the breadcrumb button numbers. 1==first step
      {courseId:@props.courseId, id: @props.post.id, stepIndex: 1}

  hideTask: ->
    StudentDashboardActions.hide(@props.post.id)
    StudentDashboardStore.on('hidden', @hidden)

  hidden: -> @setState({hidden: true})

  render: ->
    if @state.hidden then return null

    {workable} = @props
    workable ?= StudentDashboardStore.canWorkTask(@props.post)
    deleted = StudentDashboardStore.isDeleted(@props.post)
    classes = classnames("task row #{@props.className}", {workable, deleted})

    if deleted
      hideButton = <BS.Button className="-hide-button" onClick={@hideTask}>
        <i className="fa fa-close"/>
      </BS.Button>
      feedback = <span>Withdrawn</span>
    else
      text = @props.post.text
      feedback = [
        <span>{@props.feedback}</span>
        <EventInfoIcon event={@props.post} />
      ]

    <div className={classes} onClick={@onClick if workable and not deleted}
      data-event-id={@props.post.id}>
      <BS.Col xs={2}  sm={1} className={"column-icon"}>
        <i className={"icon icon-lg icon-#{@props.className}"}/>
      </BS.Col>
      <BS.Col xs={10} sm={6} className='title'>
        {@props.children}
        <Instructions
          task={@props.post}
          popverClassName='student-dashboard-instructions-popover'/>
      </BS.Col>
      <BS.Col xs={5}  sm={3} className='author'>
        {@props.post.author}
      </BS.Col>
      <BS.Col xs={5}  sm={2} className='due-at'>
        {text}
        {hideButton}
      </BS.Col>
    </div>
