React  = require 'react'
moment = require 'moment'
EmptyPanel  = require '../student-dashboard/empty-panel'
PostModal = require './post-modal'
{StudentDashboardStore} = require '../../flux/student-dashboard'

module.exports = React.createClass
  displayName: 'ForumPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    <PostModal
    courseId={@props.courseId}
    className='student-forum'
    />
