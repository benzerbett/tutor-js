React = require 'react'
BS = require 'react-bootstrap'
cn = require 'classnames'

{ExerciseStore, ExerciseActions} = require '../../flux/exercise'
{AsyncButton} = require 'openstax-react-components'
showDialog = require './unsaved-dialog'

Icon = require '../icon'

QuestionsControls = React.createClass

  propTypes:
    exercises: React.PropTypes.shape(
      all: React.PropTypes.object
      homework: React.PropTypes.object
      reading: React.PropTypes.object
    ).isRequired
    courseId: React.PropTypes.string.isRequired
    selectedExercises: React.PropTypes.array
    filter: React.PropTypes.string
    onFilterChange: React.PropTypes.func.isRequired
    sectionizerProps:  React.PropTypes.object
    onShowDetailsViewClick: React.PropTypes.func.isRequired
    onShowCardViewClick: React.PropTypes.func.isRequired

  getDefaultProps: ->
    sectionizerProps: {}

  getInitialState: -> {
    hasSaved: false
  }

  getSections: ->
    _.keys @props.exercises.all.grouped

  onFilterClick: (ev) ->
    filter = ev.currentTarget.getAttribute('data-filter')
    if filter is @props.filter then filter = ''
    @props.onFilterChange( filter )

  saveExclusions: ->
    @setState(hasSaved: true)
    ExerciseActions.saveExclusions(@props.courseId)

  resetExclusions: ->
    return unless ExerciseStore.hasUnsavedExclusions()

    showDialog('Are you sure you want to cancel?').then ->
      ExerciseActions.resetUnsavedExclusions()

  renderSaveCancelButtons: ->
    return null unless ExerciseStore.hasUnsavedExclusions() or @state.hasSaved
    saveButtonText = if ExerciseStore.hasUnsavedExclusions() then 'Save' else 'Saved'
    disabled = not ExerciseStore.hasUnsavedExclusions()
    [
        <AsyncButton key='save' bsStyle='primary' className="save"
          onClick={@saveExclusions}
          disabled={disabled}
          waitingText='Saving...'
          isWaiting={ExerciseStore.isSavingExclusions()}
        >{saveButtonText}</AsyncButton>
        <BS.Button key='cancel' className="cancel"
          disabled={disabled}
          onClick={@resetExclusions}
        >Cancel</BS.Button>
    ]

  render: ->
    sections = @getSections()

    selected = @props.selectedSection or _.first(sections)

    <div className="questions-controls">
      <BS.ButtonGroup className="filters">

        <BS.Button data-filter='all' onClick={@onFilterClick}
          className={if _.isEmpty(@props.filter) then 'all active' else 'all'}
        >
          All
        </BS.Button>

        <BS.Button data-filter='reading' onClick={@onFilterClick}
          className={if @props.filter is 'reading' then 'reading active' else 'reading'}
        >
          Reading
        </BS.Button>

        <BS.Button data-filter='homework' onClick={@onFilterClick}
          className={if @props.filter is 'homework' then 'homework active' else 'homework'}
        >
          Practice
        </BS.Button>
      </BS.ButtonGroup>

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


        {@props.children}
      <div className="save-cancel">
        {@renderSaveCancelButtons()}
      </div>
    </div>



module.exports = QuestionsControls