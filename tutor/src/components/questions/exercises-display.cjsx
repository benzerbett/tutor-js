_     = require 'underscore'
BS    = require 'react-bootstrap'
React = require 'react'

{PinnedHeaderFooterCard} = require 'shared'
{ExerciseStore, ExerciseActions} = require '../../flux/exercise'
{TocStore} = require '../../flux/toc'

Help = require './help'
Icon = require '../icon'
ExerciseControls = require './exercise-controls'
ExerciseDetails  = require '../exercises/details'
ExerciseCards    = require '../exercises/cards'
ScrollSpy        = require '../scroll-spy'
Sectionizer      = require '../exercises/sectionizer'
NoExercisesFound = require './no-exercises-found'
ExerciseHelpers  = require '../../helpers/exercise'
Dialog           = require '../tutor-dialog'
CourseGroupingLabel = require '../course-grouping-label'


ExercisesDisplay = React.createClass

  propTypes:
    courseId:    React.PropTypes.string.isRequired
    sectionIds:  React.PropTypes.array
    ecosystemId: React.PropTypes.string.isRequired

  getInitialState: -> {
    filter: ''
    currentView: 'cards'
    showingCardsFromDetailsView: false
  }
  componentWillMount:   -> ExerciseStore.on('change',  @update)
  componentWillUnmount: -> ExerciseStore.off('change', @update)
  update: -> @forceUpdate()


  onFilterChange: (filter) ->
    @setState({filter})

  renderControls: (exercises) ->

    sections = _.keys exercises.all.grouped

    if @props.showingDetails
      sectionizerProps =
        currentSection: @state.currentSection
        onSectionClick: @setCurrentSection

    <ExerciseControls
      filter={@state.filter}
      courseId={@props.courseId}
      currentView={@state.currentView}
      onFilterChange={@onFilterChange}
      onSectionSelect={@scrollToSection}
      onShowCardViewClick={@onShowCardViewClick}
      onShowDetailsViewClick={@onShowDetailsViewClick}
      exercises={exercises}
    >
      <ScrollSpy dataSelector='data-section' >
        <Sectionizer
          ref="sectionizer"
          {...sectionizerProps}
          nonAvailableWidth={600}
          onScreenElements={[]}
          chapter_sections={sections} />
      </ScrollSpy>
    </ExerciseControls>

  # called by sectionizer and details view
  setCurrentSection: (currentSection) ->
    @setState({currentSection})

  onShowDetailsViewClick: (ev, exercise) ->
    exercise ||= _.first ExerciseStore.get(@props.sectionIds)
    @setState(
      selectedExercise: exercise,
      currentView: 'details'
      currentSection: ExerciseStore.getChapterSectionOfExercise(@props.ecosystemId, exercise)
    )
    @props.onShowDetailsViewClick(ev, exercise)

  onShowCardViewClick: (ev, exercise) ->
    # The pinned header doesn't notice when the elements above it are unhidden
    # and will never unstick by itself.
    @refs.controls.unPin()
    @setState({currentView: 'cards', showingCardsFromDetailsView: true})
    @props.onShowCardViewClick(ev, exercise)

  renderMinimumExclusionWarning: (minExerciseCount) ->
    [
      <Icon key="icon" type="exclamation" />
      <div key="message" className="message">
        <p>
          Tutor needs at least {minExerciseCount} questions for this section to be
          included in spaced practice and personalized learning.
        </p>
        <p>
          If you exclude too many, your students will not get
          to practice on topics in this section.
        </p>
      </div>
    ]

  onExerciseToggle: (ev, exercise) ->
    isSelected = not ExerciseStore.isExerciseExcluded(exercise.id)
    if isSelected
      validUids = _.pluck(_.map(@props.sectionIds, TocStore.getSectionInfo), 'uuid')
      minExerciseCount = ExerciseStore.excludedAtMinimum(exercise, validUids)
    if isSelected and minExerciseCount isnt false
      Dialog.show(
        className: 'question-library-min-exercise-exclusions'
        title: '', body: @renderMinimumExclusionWarning(minExerciseCount)
        buttons: [
          <BS.Button key='exclude'
            onClick={=>
              ExerciseActions.saveExerciseExclusion(@props.courseId, exercise.id, isSelected)
              Dialog.hide()
            }>Exclude</BS.Button>

          <BS.Button key='cancel' bsStyle='primary'
            onClick={-> Dialog.hide()} bsStyle='primary'>Cancel</BS.Button>
        ]
      )
    else
      ExerciseActions.saveExerciseExclusion(@props.courseId, exercise.id, isSelected)
    @forceUpdate()

  getExerciseActions: (exercise) ->
    actions = {}
    if @getExerciseIsSelected(exercise)
      actions.include =
        message: 'Re-Add question'
        handler: @onExerciseToggle
    else
      actions.exclude =
        message: 'Remove question'
        handler: @onExerciseToggle
    if @state.currentView is 'details'
      @addDetailsActions(actions, exercise)
    else
      @addCardActions(actions, exercise)

    actions

  addDetailsActions: (actions, exercise) ->
    if @state.displayFeedback
      actions['feedback-off'] =
        message: 'Hide Feedback'
        handler: @toggleFeedback
    else
      actions['feedback-on'] =
        message: 'Preview Feedback'
        handler: @toggleFeedback
    actions['report-error'] =
        message: 'Report an error'
        handler: @reportError


  addCardActions: (actions, exercise) ->
    actions.details =
      message: 'Question details'
      handler: @onShowDetailsViewClick

  reportError: (ev, exercise) ->
    ExerciseHelpers.openReportErrorPage(exercise)

  toggleFeedback: ->
    @setState(displayFeedback: not @state.displayFeedback)

  getExerciseIsSelected: (exercise) ->
    ExerciseStore.isExerciseExcluded(exercise.id)

  renderExercises: (exercises) ->

    return <NoExercisesFound /> unless exercises.count

    sharedProps =
        exercises: exercises
        onExerciseToggle: @onExerciseToggle
        getExerciseActions: @getExerciseActions
        getExerciseIsSelected: @getExerciseIsSelected
        ecosystemId: @props.ecosystemId
        topScrollOffset: 190

    if @props.showingDetails
      <ExerciseDetails
        {...sharedProps}
        selectedExercise={@state.selectedExercise}
        selectedSection={@state.currentSection}
        onSectionChange={@setCurrentSection}
        onExerciseToggle={@onExerciseToggle}
        displayFeedback={@state.displayFeedback}
        onShowCardViewClick={@onShowCardViewClick} />
    else
      <ExerciseCards
        {...sharedProps}
        watchStore={ExerciseStore}
        watchEvent='change-exercise-'
        onExerciseToggle={@onExerciseToggle}
        onShowDetailsViewClick={@onShowDetailsViewClick} />

  render: ->
    return null if ExerciseStore.isLoading() or _.isEmpty(@props.sectionIds)

    exercises = ExerciseStore.groupBySectionsAndTypes(@props.ecosystemId, @props.sectionIds, withExcluded: true)
    <div className="exercises-display">

      <PinnedHeaderFooterCard
        ref='controls'
        containerBuffer={50}
        header={@renderControls(exercises)}
        cardType='sections-questions'
      >

      <div className="instructions">
        <div className="wrapper">
          {Help.forCourseId(@props.courseId).second.bar}
        </div>
      </div>

      {@renderExercises(
        if @state.filter then exercises[@state.filter] else exercises.all
      )}

      </PinnedHeaderFooterCard>
    </div>


module.exports = ExercisesDisplay
