React  = require 'react'
BS     = require 'react-bootstrap'
ForumPanel   = require '../integrated-forum/forum-panel'
ForumToolbar   = require '../integrated-forum/forum-toolbar'

module.exports = React.createClass
  displayName: 'TeacherForum'

  propTypes:
    courseId: React.PropTypes.string.isRequired


  contextTypes:
    router: React.PropTypes.func
  render: ->
    courseId = @props.courseId
    <div className="course-scores-wrap">
      <span className='course-scores-title'>Forum</span>
        <BS.Row>
          <BS.Col xs=12 md=12 lg=12>
              <ForumPanel courseId={courseId}/>
          </BS.Col>
        </BS.Row>
    </div>
