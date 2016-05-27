React = require 'react'
BS = require 'react-bootstrap'
_  = require 'underscore'

ScrollSpy   = require '../../scroll-spy'
Sectionizer = require '../../exercises/sectionizer'
Icon        = require '../../icon'

{TaskPlanStore, TaskPlanActions} = require '../../../flux/task-plan'

ExerciseControls = React.createClass

  propTypes:
    planId:              React.PropTypes.string.isRequired
    canAdd:              React.PropTypes.bool
    canEdit:             React.PropTypes.bool
    canReview:           React.PropTypes.bool
    addClicked:          React.PropTypes.func
    reviewClicked:       React.PropTypes.func
    sectionizerProps:    React.PropTypes.object
    hideDisplayControls: React.PropTypes.bool

  addTutorSelection: ->
    TaskPlanActions.updateTutorSelection(@props.planId, 1)

  removeTutorSelection: ->
    TaskPlanActions.updateTutorSelection(@props.planId, -1)

  renderDisplayControls: ->
    if @props.hideDisplayControls
      <div className="controls" />
    else
      <div className="controls">
        <ScrollSpy dataSelector='data-section' >
          <Sectionizer
            ref="sectionizer"
            {...@props.sectionizerProps}
            nonAvailableWidth={1000}
            onScreenElements={[]}
          />
        </ScrollSpy>

        <BS.ButtonGroup className="display-types">
          <BS.Button onClick={@props.onShowCardViewClick}
            className={if @props.currentView is 'cards' then 'cards active' else 'cards'}
          >
            <Icon type="th-large" />
          </BS.Button>

          <BS.Button onClick={@props.onShowDetailsViewClick}
            className={if @props.currentView is 'details' then 'details active' else 'details'}
          >
            <Icon type="mobile" />
          </BS.Button>
        </BS.ButtonGroup>
      </div>


  renderExplanation: ->
    return null if @props.canAdd
    <div className="tutor-added-later">
      <span>
        Tutor selections are added later to support spaced practice and personalized learning.
      </span>
    </div>

  renderActionButtons: ->
    if @props.canReview and TaskPlanStore.exerciseCount(@props.planId)
      [
        <BS.Button
          key='next'
          bsStyle="primary"
          className="-review-exercises"
          onClick={@props.reviewClicked}>Next</BS.Button>
        <BS.Button
          key='cancel'
          bsStyle="default"
          className="-cancel-add"
          onClick={@props.onCancel}>Cancel</BS.Button>
      ]
    else if @props.canAdd
      <BS.Button bsStyle="default"
        className="-add-exercises"
        onClick={@props.addClicked}>Add More...</BS.Button>
    else
      null

  canChangeTutorQty: ->
    @props.canEdit or @props.canAdd

  renderIncreaseButton: ->
    return null unless @canChangeTutorQty() and TaskPlanStore.canIncreaseTutorExercises(@props.planId)
    <BS.Button onClick={@addTutorSelection} className="btn-xs">
      <Icon type='arrow-up' />
    </BS.Button>

  renderDecreaseButton: ->
    return null unless @canChangeTutorQty() and TaskPlanStore.canDecreaseTutorExercises(@props.planId)
    <BS.Button onClick={@removeTutorSelection} className="btn-xs">
      <Icon type='arrow-down' />
    </BS.Button>

  render: ->
    numSelected = TaskPlanStore.exerciseCount(@props.planId)
    numTutor = TaskPlanStore.getTutorSelections(@props.planId)

    <div className="exercise-controls-bar">
      {@renderDisplayControls()}

      <div className="indicators">
        <div className="num total">
          <h2>{numSelected + numTutor}</h2>
          <span>Total Problems</span>
        </div>

        <div className="num mine">
          <h2>{numSelected}</h2>
          <span>My Selections</span>
        </div>

        <div className="num tutor">
          <div className="tutor-selections">
            {@renderDecreaseButton()}
            <h2>{numTutor}</h2>
            {@renderIncreaseButton()}
          </div>
          <span>Tutor Selections</span>
        </div>

        {@renderExplanation()}

        <div className="actions">
          {@renderActionButtons()}
        </div>

      </div>
    </div>

module.exports = ExerciseControls
