React  = require 'react'
moment = require 'moment'
EmptyPanel  = require '../student-dashboard/empty-panel'
TeacherPostsPanel = require './teacher-posts-panel'
{ForumActions, ForumStore} = require '../../flux/forum'
LoadableItem = require '../loadable-item'
ForumToolbar   = require './forum-toolbar'

TeacherForumPanel = React.createClass
  displayName: 'TeacherForumPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    posts  = ForumStore.postsByRecent(@props.courseId)
    if posts.length
      <TeacherPostsPanel
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
    <LoadableItem
      id={courseId}
      store={ForumStore}
      actions={ForumActions}
      renderItem={ ->
        <div className='teacher-forum '>
          <ForumToolbar courseId={courseId}/>
          <TeacherForumPanel courseId={courseId}/>
        </div>}
    />

module.exports = ForumPanelShell
