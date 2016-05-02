React = require 'react'
BS = require 'react-bootstrap'
classnames = require 'classnames'

URLs = require '../../model/urls'
Notifications = require '../../model/notifications'

EmailNotification = React.createClass
  propTypes:
    notice: React.PropTypes.shape(
      id: React.PropTypes.number.isRequired
      value: React.PropTypes.string.isRequired
    ).isRequired

  acknowledge: ->
    Notifications.acknowledge(@props.notice)
    undefined # silence React warning about return value

  # If used elsewhere, the on/off dance needs to be extracted to a component
  componentWillMount: ->
    @props.notice.on('change', @onChange)
  componentWillUnmount: ->
    @props.notice.off('change', @onChange)
  componentWillReceiveProps: (nextProps) ->
    if nextProps.notice and nextProps.notice isnt @props.notice
      @props.notice.off('change', @onChange)
      nextProps.notice.on('change', @onChange)

  onChange: ->
    @forceUpdate()

  onVerify: ->
    @props.notice.sendVerification()

  onPinCheck: ->
    @props.notice.verify( @refs.verifyInput.getValue(), @onSuccess)

  renderSpinner: ->
    <span className="body">
      <span className="message">
        Requesting...
      </span>
      <i className='fa fa-spin fa-2x fa-spinner' />
    </span>

  renderStart: ->
    <span className="body">
      Verifying your email address allows you to recover your password if you ever forget it.
      <a className='action' onClick={@onVerify}>Verify now</a>
    </span>

  onVerifyKey: (ev) ->
    if ev.key is 'Enter'
      @onPinCheck()

  renderPin: ->
    _.defer =>
      @refs.verifyInput?.getInputDOMNode().focus()
    <span className="body verify">
      <span className="message">
        Check your email inbox. Enter the 6-digit verification code:
      </span>
      <BS.Input autofocus ref='verifyInput' onKeyPress={@onVerifyKey} type="text" />
      <a className='pin-check action' onClick={@onPinCheck}>Go</a>
    </span>

  renderFailure: ->
    <span className="body">
      <a href={URLs.get('accounts_profile')} className="action" target="_blank">
        Visit Profile >>
      </a>
    </span>

  renderSuccess: ->
    <span className="body">
      <span className="message">Verification was successful!</span>
    </span>


  onSuccess: ->
    # wait a bit so the "Success" message is seen, then hide
    _.delay =>
      Notifications.acknowledge(@props.notice)
    , 1500

  render: ->

    body = if @props.notice.is_verified
      @renderSuccess()
    else if @props.notice.requestInProgress
      @renderSpinner()
    else if @props.notice.verifyInProgress
      if @props.notice.verificationFailed
        @renderFailure()
      else
        @renderPin()
    else
      @renderStart()

    if @props.notice.error
      error =
        <span className="error">
          <i className='icon fa fa-exclamation-circle' />
          <span className="body">{@props.notice.error}</span>
        </span>

    classNames = classnames('notification','email',
      {'with-error': @props.notice.error}
    )
    <div className={classNames}>
      <i className='icon fa fa-envelope-o' />
      {error}
      {body}
    </div>


module.exports = EmailNotification
