React = require 'react'
BS = require 'react-bootstrap'

{ForumStore, ForumActions} = require '../../flux/forum'
LoadableItem = require '../loadable-item'
isStepComplete = (step) -> step.is_completed
TeacherForum = require './dashboard'

TeacherForumShell = React.createClass
  displayName: 'TeacherForumShell'

  contextTypes:
    router: React.PropTypes.func

  render: ->
    {courseId} = @context.router.getCurrentParams()
    <BS.Panel className='student-dashboard '>
      <LoadableItem
        id={courseId}
        store={ForumStore}
        actions={ForumActions}
        renderItem={ -> <TeacherForum courseId={courseId}/> }
      />
    </BS.Panel>

module.exports = {TeacherForumShell}
