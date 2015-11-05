React = require 'react'

user = require './model'
api = require '../api'

getWaitingText = (status) ->
  "#{status}…"

UserStatus = React.createClass

  componentWillMount: ->
    user.ensureStatusLoaded()
    user.channel.on("change", @update)

  componentWillUnmount: ->
    user.channel.off("change", @update)

  update: ->
    @forceUpdate() if @isMounted()

  render: ->
    status = if user.isLoggedIn() then "logged in as #{user.name}" else 'an unknown user'
    <span>You are {status}</span>


module.exports = UserStatus
