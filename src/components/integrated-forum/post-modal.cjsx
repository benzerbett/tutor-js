###
THIS FILE IS DEPRECATED. All needed code has been inserted into
forum-toolbar.cjsx to be refactored more nicely later
###

React  = require 'react'
BS     = require 'react-bootstrap'
#ModalHeader = require 'react-bootstrap/lib/ModalHeader'
Time   = require '../time'


{ForumActions, ForumStore} = require '../../flux/forum'
EventInfoIcon = require '../student-dashboard/event-info-icon'
{Instructions} = require '../task/details'
classnames = require 'classnames'
PostForm = require './post-form'

window.ForumStore = ForumStore
window.ForumActions = ForumActions

module.exports = React.createClass
  displayName: 'PostModal'

  propTypes:
    className: React.PropTypes.string.isRequired
    courseId:  React.PropTypes.string.isRequired

  getInitialState: ->
    showModal :false

  close: -> @setState({showModal:false})

  open: -> @setState({showModal:true})

  handleCommentSubmit: (newPost)->
    @setState({showModal:false})
    ForumActions.save(@props.courseId, newPost)

  render: ->

    classes = classnames("row #{@props.className}")

    <div className={classes}>

     <BS.Row className="retract-row">
        <BS.Col xs={2} sm={2} xsOffset={9} smOffset={9} className="new-post">
          <BS.Button className="-hide-button" onClick={@open}>
            New Post
          </BS.Button>

          <BS.Modal show={@state.showModal} onHide={@close}>

            <ModalHeader closeButton>
              <BS.Modal.Title>New Post</BS.Modal.Title>
            </ModalHeader>

            <BS.Modal.Body>
              <PostForm onCommentSubmit = {@handleCommentSubmit}/>
            </BS.Modal.Body>

            <BS.Modal.Footer>

            </BS.Modal.Footer>

          </BS.Modal>

        </BS.Col>
      </BS.Row>

    </div>
