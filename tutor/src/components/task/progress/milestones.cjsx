React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'
BS = require 'react-bootstrap'
classnames = require 'classnames'

{ChapterSectionMixin, ArbitraryHtmlAndMath } = require 'shared'
{BreadcrumbStatic} = require '../../breadcrumb'

{TaskStepActions, TaskStepStore} = require '../../../flux/task-step'
{TaskProgressActions, TaskProgressStore} = require '../../../flux/task-progress'
{TaskPanelActions, TaskPanelStore} = require '../../../flux/task-panel'
{TaskStore} = require '../../../flux/task'
{StepTitleStore} = require '../../../flux/step-title'

ReactCSSTransitionGroup = require 'react-addons-css-transition-group'

Milestone = React.createClass
  displayName: 'Milestone'
  propTypes:
    goToStep: React.PropTypes.func.isRequired
    crumb: React.PropTypes.object.isRequired
    currentStep: React.PropTypes.number.isRequired

  handleKeyUp: (crumbKey, keyEvent) ->
    if keyEvent.keyCode is 13 or keyEvent.keyCode is 32
      @props.goToStep(crumbKey)
      keyEvent.preventDefault()

  render: ->
    {goToStep, crumb, currentStep, stepIndex} = @props

    isCurrent = stepIndex is currentStep

    classes = classnames 'milestone', "milestone-#{crumb.type}",
      'active': isCurrent

    previewText = StepTitleStore.getTitleForCrumb(@props.crumb)

    if crumb.type is 'exercise'
      preview = <ArbitraryHtmlAndMath
        block={true}
        className='milestone-preview'
        html={previewText}/>
    else
      preview = <div className='milestone-preview'>{previewText}</div>

    goToStepForCrumb = _.partial(goToStep, stepIndex)

    <BS.Col xs=3 lg=2 className='milestone-wrapper'>
      <div
        tabIndex='0'
        className={classes}
        aria-label={previewText}
        onClick={goToStepForCrumb}
        onKeyUp={_.partial(@handleKeyUp, stepIndex)}
      >
        <BreadcrumbStatic
          crumb={crumb}
          data-label={crumb.label}
          currentStep={currentStep}
          goToStep={goToStepForCrumb}
          stepIndex={stepIndex}
          key="breadcrumb-#{crumb.type}-#{stepIndex}"
          ref="breadcrumb-#{crumb.type}-#{stepIndex}"
        />
        {preview}
      </div>
    </BS.Col>

Milestones = React.createClass
  displayName: 'Milestones'

  mixins: [ChapterSectionMixin]

  propTypes:
    id: React.PropTypes.string.isRequired
    goToStep: React.PropTypes.func.isRequired

  getInitialState: ->
    currentStep = TaskProgressStore.get(@props.id)
    crumbs = TaskPanelStore.get(@props.id)

    currentStep: currentStep
    crumbs: crumbs

  componentWillMount: ->
    bStyle = document.body.style
    @_bodyOverflowStyle = bStyle.overflow
    bStyle.overflow = 'hidden'

  componentDidMount: ->
    @switchCheckingClick()
    @switchTransitionListen()

  componentWillUnmount: ->
    @switchCheckingClick(false)
    @switchTransitionListen(false)
    bStyle = document.body.style
    bStyle.overflow = @_bodyOverflowStyle

  componentDidEnter: (transitionEvent) ->
    @props.handleTransitions?(transitionEvent) if transitionEvent.propertyName is 'transform'

  switchTransitionListen: (switchOn = true) ->
    eventAction = if switchOn then 'addEventListener' else 'removeEventListener'

    milestones = ReactDOM.findDOMNode(@)
    milestones[eventAction]('transitionend', @componentDidEnter)
    milestones[eventAction]('webkitTransitionEnd', @componentDidEnter)

  switchCheckingClick: (switchOn = true) ->
    eventAction = if switchOn then 'addEventListener' else 'removeEventListener'

    document[eventAction]('click', @checkAllowed, true)
    document[eventAction]('focus', @checkAllowed, true)

  checkAllowed: (focusEvent) ->
    modal = ReactDOM.findDOMNode(@)

    unless modal.contains(focusEvent.target) or @props.filterClick?(focusEvent)
      focusEvent.preventDefault()
      focusEvent.stopImmediatePropagation()
      modal.focus()

  goToStep: (args...) ->
    unless @props.goToStep(args...)
      @props.closeMilestones()

  render: ->
    {crumbs, currentStep} = @state

    stepButtons = _.map crumbs, (crumb, crumbIndex) =>
      <Milestone
        key={"crumb-wrapper-#{crumbIndex}"}
        crumb={crumb}
        goToStep={@goToStep}
        stepIndex={crumbIndex}
        currentStep={currentStep}
      />

    classes = 'task-breadcrumbs'

    <div className='milestones-wrapper' role='dialog' tabIndex='-1'>
      <div className='milestones task-breadcrumbs' role='document'>
        {stepButtons}
      </div>
    </div>

module.exports = {Milestones, Milestone}
