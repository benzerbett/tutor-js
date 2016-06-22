React  = require 'react'
moment = require 'moment'
EmptyPanel  = require '../student-dashboard/empty-panel'
PostsPanel = require './posts-panel'
{StudentDashboardStore} = require '../../flux/student-dashboard'

module.exports = React.createClass
  displayName: 'ForumPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    posts  = StudentDashboardStore.posts(@props.courseId)
    if posts.length
      <PostsPanel
        className='-forum'
        onTaskClick={@onTaskClick}
        courseId={@props.courseId}
        posts=posts
        title='Forum Posts'
      />
    else
      <EmptyPanel>No Forum Posts</EmptyPanel>
