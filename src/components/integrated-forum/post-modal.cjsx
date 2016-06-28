React  = require 'react'
BS     = require 'react-bootstrap'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'
Time   = require '../time'
#require 'draft-js'


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
    # post:     React.PropTypes.object.isRequired
    courseId:  React.PropTypes.string.isRequired
    # feedback:  React.PropTypes.string.isRequired
  getInitialState: ->
    showModal :false
  close: -> @setState({showModal:false})
  open: -> @setState({showModal:true})
  handleCommentSubmit: (newPost)->
    @setState({showModal:false})
    ForumActions.save(@props.courseId, newPost)


  render: ->

    classes = classnames("task row #{@props.className}")

    <div className={classes}>
      <BS.Col xs={2}  sm={1} className={"column-icon"}>
      </BS.Col>
      <BS.Col xs={10} sm={6} className='title'>
      </BS.Col>
      <BS.Col xs={5}  sm={3} className='author'>
      </BS.Col>
      <BS.Col xs={5}  sm={2} className='post-date'>
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
            <BS.Button className="-hide-button" onClick={@close}>
              Close
            </BS.Button>
          </BS.Modal.Footer>

        </BS.Modal>

      </BS.Col>

    </div>
