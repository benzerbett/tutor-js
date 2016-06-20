React  = require 'react'
moment = require 'moment'
EmptyPanel  = require './empty-panel'

module.exports = React.createClass
  displayName: 'UpcomingPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    <EmptyPanel>No forum posts</EmptyPanel>
