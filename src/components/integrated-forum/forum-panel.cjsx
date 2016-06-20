React  = require 'react'
moment = require 'moment'
EmptyPanel  = require '../student-dashboard/empty-panel'

module.exports = React.createClass
  displayName: 'ForumPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    <EmptyPanel>No Forum Posts</EmptyPanel>
