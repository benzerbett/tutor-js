React  = require 'react'
moment = require 'moment'
EmptyPanel  = require '../student-dashboard/empty-panel'
PostsPanel = require './posts-panel'
{ForumActions, ForumStore} = require '../../flux/forum'
LoadableItem = require '../loadable-item'
ForumToolbar   = require './forum-toolbar'

ForumPanel = React.createClass
  displayName: 'ForumPanel'
  propTypes:
    courseId: React.PropTypes.string.isRequired

  render: ->
    posts  = ForumStore.postsByRecent(@props.courseId)
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
    <LoadableItem
      id={courseId}
      store={ForumStore}
      actions={ForumActions}
      renderItem={ ->
        <div className='student-forum '>
          <ForumToolbar courseId={courseId}/>
          <ForumPanel courseId={courseId}/>
        </div>}
    />

module.exports = ForumPanelShell
