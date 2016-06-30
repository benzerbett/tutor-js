React  = require 'react'
BS     = require 'react-bootstrap'
moment = require 'moment'
{ForumActions, ForumStore} = require '../../flux/forum'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'
classnames = require 'classnames'
PostForm = require './post-form'
PostModal = require './post-modal'
DropdownButton = require 'react-bootstrap/lib/DropdownButton'
MenuItem = require 'react-bootstrap/lib/MenuItem'


window.ForumStore = ForumStore
window.ForumActions = ForumActions

module.exports = React.createClass
  displayName: 'ForumToolbar'

  propTypes:
    courseId: React.PropTypes.string.isRequired

  getInitialState: ->
    showModal :false

  closeModal: ->
    @setState({showModal:false})

  openModal: ->
    @setState({showModal:true})

  handleCommentSubmit: (newPost)->
    @setState({showModal:false})
    ForumActions.save(@props.courseId, newPost)

  render: ->
    classes = classnames("toolbar row")

    <div className="forum-toolbar">
      <BS.Row className={classes}>

        <BS.Col xs={3} sm={3} xsOffset={0} smOffset={0} className = "toolbar-tag">
          <DropdownButton bsStyle='success' title='Tag' className = "toolbar-tag-button" id='dropdown-basic-1'>
            <MenuItem eventKey="1" className = "toolbar-tag-menu">Chapter1</MenuItem>
            <MenuItem eventKey="2" className = "toolbar-tag-menu">Chapter2</MenuItem>
            <MenuItem eventKey="3" className = "toolbar-tag-menu">Chapter3</MenuItem>
            <MenuItem eventKey="4" className = "toolbar-tag-menu">Chapter4</MenuItem>
          </DropdownButton>
        </BS.Col>

        <BS.Col xs={2} sm={2} className="new-post-modal pull-right">
          <BS.Button bsStyle="primary" className="new-post-button" onClick={@openModal}>
            {"New Post"}
          </BS.Button>
          <BS.Modal className="post-form-modal" show={@state.showModal} onHide={@closeModal}>

            <ModalHeader closeButton className="post-form-header">
              <BS.Modal.Title>{"New Post"}</BS.Modal.Title>
            </ModalHeader>

            <BS.Modal.Body className="post-form-body">
              <PostForm onCommentSubmit = {@handleCommentSubmit}/>
            </BS.Modal.Body>

            <BS.Modal.Footer>
            </BS.Modal.Footer>

          </BS.Modal>
        </BS.Col>
      </BS.Row>
    </div>
