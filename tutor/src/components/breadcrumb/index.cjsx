_ = require 'underscore'
React = require 'react'
{Breadcrumb} = require 'shared'

{StepPanel} = require '../../helpers/policies'

{TaskStepActions, TaskStepStore} = require '../../flux/task-step'
{TaskStore} = require '../../flux/task'

BreadcrumbStatic = React.createClass
  displayName: 'BreadcrumbStatic'
  propTypes:
    crumb: React.PropTypes.shape(
      type: React.PropTypes.string.isRequired
      data: React.PropTypes.shape(
        id: React.PropTypes.string.isRequired
        task_id: React.PropTypes.string.isRequired
      ).isRequired
    ).isRequired

  componentWillMount: ->
    @setStep(@props)

  setStep: (props) ->
    {crumb} = props

    step = crumb.data
    if crumb.type is 'step'
      step = crumb.data

    @setState({step})

  render: ->
    {step} = @state
    crumbProps = _.omit(@props, 'step')
    step = _.first(step) if _.isArray(step)

    <Breadcrumb
      {...crumbProps}
      step={step}/>

BreadcrumbTaskDynamic = React.createClass
  propTypes:
    crumb: React.PropTypes.shape(
      type: React.PropTypes.string.isRequired
      data: React.PropTypes.shape(
        id: React.PropTypes.number.isRequired
        task_id: React.PropTypes.number.isRequired
      ).isRequired
    ).isRequired
    onMount: React.PropTypes.func

  displayName: 'BreadcrumbTaskDynamic'
  componentWillMount: ->
    {crumb} = @props

    @setStep(@props)

    TaskStepStore.on('step.completed', @update)

    if crumb.type is 'step' and TaskStepStore.isPlaceholder(crumb.data.id)
      TaskStepStore.on('step.completed', @checkPlaceholder)
      TaskStepStore.on('step.loaded', @update)

  removeListeners: ->
    TaskStepStore.off('step.completed', @update)
    TaskStepStore.off('step.completed', @checkPlaceholder)
    TaskStepStore.off('step.loaded', @update)

  componentWillUnmount: ->
    @removeListeners()

  componentDidMount: ->
    @props.onMount?()

  setStep: (props) ->
    {crumb} = props

    step = crumb.data
    if crumb.type is 'step'
      # get the freshest version of the step
      step = TaskStepStore.get(crumb.data.id)

    canReview = StepPanel.canReview(step.id) if crumb.type is 'step' and step?

    @setState({step, canReview})

  checkPlaceholder: ->
    {task_id, id} = @props.crumb.data
    unless TaskStore.hasIncompleteCoreStepsIndexes(task_id)
      TaskStepActions.loadPersonalized(id)

  update: (id) ->
    {crumb} = @props

    if (crumb.data.id is id)
      @setStep(@props)

  render: ->
    {step} = @state
    crumbProps = _.omit(@props, 'step')

    <Breadcrumb
      {...crumbProps}
      step={step}/>

module.exports = {BreadcrumbTaskDynamic, BreadcrumbStatic}
