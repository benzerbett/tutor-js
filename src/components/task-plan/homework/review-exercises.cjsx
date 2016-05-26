React = require 'react'
BS = require 'react-bootstrap'
_ = require 'underscore'

Icon = require '../../icon'
LoadingExercises = require './loading-exercises-mixin'
{TaskPlanStore, TaskPlanActions} = require '../../../flux/task-plan'
{ExerciseStore} = require '../../../flux/exercise'
{ExercisePreview} = require 'openstax-react-components'
{PinnedHeaderFooterCard} = require 'openstax-react-components'

ExerciseSummary = require './exercise-summary'
ExerciseTable   = require './exercises-table'

ReviewExerciseCard = React.createClass

  propTypes:
    planId:   React.PropTypes.string.isRequired
    exercise: React.PropTypes.object.isRequired
    canEdit:  React.PropTypes.bool.isRequired
    isFirst:  React.PropTypes.bool.isRequired
    isLast:   React.PropTypes.bool.isRequired
    index:    React.PropTypes.number.isRequired


  moveExerciseUp: ->
    TaskPlanActions.moveExercise(@props.planId, @props.exercise, -1)

  moveExerciseDown: ->
    TaskPlanActions.moveExercise(@props.planId, @props.exercise, 1)

  removeExercise: ->
    if confirm('Are you sure you want to remove this exercise?')
      TaskPlanActions.removeExercise(@props.planId, @props.exercise)

  getActionButtons: ->
    return null unless @props.canEdit

    <span className="pull-right card-actions">
      {<BS.Button onClick={@moveExerciseUp} className="btn-xs -move-exercise-up">
         <Icon type='arrow-up' />
       </BS.Button> unless @props.isFirst}
      {<BS.Button onClick={@moveExerciseDown} className="btn-xs -move-exercise-down">
         <Icon type='arrow-down' />
       </BS.Button> unless @props.isLast}
      <BS.Button onClick={@removeExercise} className="btn-xs -remove-exercise">
        <Icon type='close' />
      </BS.Button>
    </span>

  renderHeader: ->
    actionButtons = @getActionButtons()
    <span className="-exercise-header">
      <span className="exercise-number">{@props.index + 1}</span>
      {actionButtons}
    </span>

  render: ->
    <div className="openstax exercise-wrapper">
      <ExercisePreview
        exercise={@props.exercise}
        className='exercise-card'
        isInteractive={false}
        isVerticallyTruncated={true}
        isSelected={false}
        header={@renderHeader()}
        panelStyle='default'
      />
    </div>


ReviewExercises = React.createClass

  mixins: [LoadingExercises]


  propTypes:
    planId: React.PropTypes.string.isRequired
    courseId: React.PropTypes.string.isRequired
    canEdit: React.PropTypes.bool
    pageIds: React.PropTypes.array



  render: ->
    return null unless @props.isVisible
    return @renderLoading() if @exercisesAreLoading()
    unless TaskPlanStore.getTopics(@props.planId).length
      return <div className='-bug'>Failed loading exercises</div>

    {courseId, pageIds, planId} = @props

    exerciseSummary = <ExerciseSummary
      onCancel={@cancel}
      onPublish={@publish}
      canAdd={@props.canAdd}
      addClicked={@showSectionTopics}
      planId={planId}/>

    exerciseTable = <ExerciseTable
      courseId={courseId}
      sectionIds={@props.sectionIds}
      planId={planId}/>

    exercise_ids = TaskPlanStore.getExercises(planId)
    exercises = _.map(exercise_ids, ExerciseStore.getExerciseById)

    <PinnedHeaderFooterCard
      containerBuffer={50}
      header={exerciseSummary}
      cardType='homework-builder'>
      {exerciseTable}
      <div className="card-list exercises">
        {for exercise, i in exercises
          <ReviewExerciseCard
            key={exercise.id}
            index={i}
            planId={@props.planId}
            canEdit={@props.canEdit}
            isFirst={i is 0}
            isLast={i is exercises.length - 1}
            exercise={exercise}/>}
      </div>
    </PinnedHeaderFooterCard>



module.exports = ReviewExercises
