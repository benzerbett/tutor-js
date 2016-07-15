React = require 'react'
BS = require 'react-bootstrap'

{StudentDashboardStore, StudentDashboardActions} = require '../../flux/student-dashboard'
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
        store={StudentDashboardStore}
        actions={StudentDashboardActions}
        renderItem={ -> <TeacherForum courseId={courseId}/> }
      />
    </BS.Panel>

module.exports = {TeacherForumShell}
