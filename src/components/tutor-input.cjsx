React = require 'react'
BS = require 'react-bootstrap'
moment = require 'moment'

{TimeStore} = require '../flux/time'
DatePicker = require 'react-datepicker'

TutorInput = React.createClass
  propTypes:
    label: React.PropTypes.string.isRequired
    id: React.PropTypes.string
    className: React.PropTypes.string
    type: React.PropTypes.string
    onChange: React.PropTypes.func
    value: React.PropTypes.any

  onChange: (event) ->
    @props.onChange(event.target?.value, event.target)

  render: ->
    classes = ['form-control']
    wrapperClasses = ["form-control-wrapper", "tutor-input"]
    wrapperClasses.push(@props.className) if @props.className

    unless @props.default then classes.push('empty')
    if @props.required then wrapperClasses.push('is-required')
    classes.push(@props.class)

    <div className={wrapperClasses.join(' ')}>
      <input
        id={@props.id}
        type='text'
        className={classes.join(' ')}
        value={@props.value}
        defaultValue={@props.default}
        onChange={@onChange}
      />
      <div className="floating-label">{@props.label}</div>
      <div className="hint required-hint">
        Required Field <i className="fa fa-exclamation-circle"></i>
      </div>
    </div>

TutorDateInput = React.createClass

  getInitialState: ->
    {expandCalendar: false}

  expandCalendar: ->
    @setState({expandCalendar: true, hasFocus: true})

  isValid: (value) ->
    valid = true
    valid = false if (@props.min and value < @props.min)
    valid = false if (@props.max and value > @props.max)
    valid

  dateSelected: (value) ->
    valid = @isValid(value)

    if (not valid)
      value = @props.min or null

    date = new Date(value)
    @props.onChange(date)
    @setState({expandCalendar: false, valid: valid, value: date})

  onToggle: (open) ->
    @setState({expandCalendar: open})

  clickHandler: (event) ->
    if (event.target.tagName is "INPUT" and not @state.expandCalendar)
      @setState({expandCalendar: true})

  onBlur: (event) ->
    @setState({hasFocus: false})

  render: ->
    classes = ['form-control']
    wrapperClasses = ["form-control-wrapper", "tutor-input"]

    now = TimeStore.getNow()
    value = if @props.value then new moment(@props.value) else null
    min = if @props.min then new moment(@props.min) else new moment(now).subtract(10, 'years')
    max = if @props.max then new moment(@props.max) else new moment(now).add(10, 'years')

    if not @props.value and not @state.hasFocus
      classes.push('empty')

    if @state.expandCalendar and not @props.readOnly
      onToggle = @onToggle

    if @props.required then wrapperClasses.push('is-required')

    <div className={wrapperClasses.join(' ')}>
      <input type='text' disabled className={classes.join(' ')} />
      <div className="floating-label">{@props.label}</div>
      <div className="hint required-hint">
        Required Field <i className="fa fa-exclamation-circle"></i>
      </div>

      <div className="date-wrapper">
        <DatePicker 
          minDate={min}
          maxDate={max}
          onFocus={@expandCalendar}
          dateFormat="YYYY/MM/DD"
          onBlur={@onBlur}
          key={@props.id}
          ref="picker"
          className={classes.join(' ')}
          onChange={@dateSelected}
          readOnly={@props.readOnly}
          selected={value}
        />
        <i className="fa fa-calendar"></i>
      </div>
    </div>


TutorTextArea = React.createClass
  propTypes:
    label: React.PropTypes.string.isRequired
    id: React.PropTypes.string
    className: React.PropTypes.string
    onChange: React.PropTypes.func
    value: React.PropTypes.any

  resize: (event) ->
    event.target.style.height = ''
    event.target.style.height = "#{event.target.scrollHeight}px"

  onChange: (event) ->
    @props.onChange(event.target?.value, event.target)

  render: ->
    classes = ['form-control']
    wrapperClasses = ["form-control-wrapper", "tutor-input"]
    wrapperClasses.push(@props.className) if @props.className
    unless @props.default then classes.push('empty')
    if @props.required then wrapperClasses.push('is-required')
    classes.push(@props.inputClass)

    <div className={wrapperClasses.join(' ')}>
      <textarea
        id={@props.inputId}
        ref='textarea'
        type='text'
        onKeyUp={@resize}
        onPaste={@resize}
        className={classes.join(' ')}
        defaultValue={@props.default}
        onChange={@onChange} />
      <div className="floating-label">{@props.label}</div>
      <div className="hint required-hint">
        Required Field <i className="fa fa-exclamation-circle"></i>
      </div>
    </div>

module.exports = {TutorInput, TutorDateInput, TutorTextArea}
