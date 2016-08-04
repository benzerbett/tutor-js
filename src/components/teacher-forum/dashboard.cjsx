React  = require 'react'
BS     = require 'react-bootstrap'
TeacherForumPanel   = require '../integrated-forum/teacher-forum-panel'

module.exports = React.createClass
  displayName: 'TeacherForum'

  propTypes:
    courseId: React.PropTypes.string.isRequired


  contextTypes:
    router: React.PropTypes.func
  render: ->
    courseId = @props.courseId
    <div className="teacher-forum-wrap">
      <span className='teacher-forum-title'>Forum</span>
        <BS.Row>
          <BS.Col xs=12 md=12 lg=12>
              <TeacherForumPanel courseId={courseId}/>
          </BS.Col>
        </BS.Row>
    </div>
