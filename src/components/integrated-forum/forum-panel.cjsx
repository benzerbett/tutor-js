React  = require 'react'
moment = require 'moment'
EmptyPanel  = require '../student-dashboard/empty-panel'
PostsPanel = require './posts-panel'
{StudentDashboardStore} = require '../../flux/student-dashboard'
{ForumActions, ForumStore} = require '../../flux/forum'
LoadableItem = require '../loadable-item'

ForumPanel = React.createClass
  displayName: 'ForumPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    posts  = ForumStore.posts(@props.courseId)
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



ForumPanelShell = React.createClass
  displayName: 'ForumPanelShell'
  contextTypes:
    router: React.PropTypes.func
    
  render: ->
    {courseId} = @context.router.getCurrentParams()
    <div className='student-forum '>
      <LoadableItem
      id={courseId}
      store={ForumStore}
      actions={ForumActions}
      renderItem={ -> <ForumPanel courseId={courseId}/> }
      />
    </div>

module.exports = ForumPanelShell
