React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
moment = require 'moment'
classnames = require 'classnames'
_ = require 'underscore'
{ForumActions, ForumStore} = require '../../flux/forum'
{TimeStore} = require '../../flux/time'
moment = require 'moment-timezone'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'

module.exports = React.createClass
  displayName: 'TeacherComment'

  propTypes:
    post: React.PropTypes.object.isRequired
    comment: React.PropTypes.object.isRequired
    confirmDeletion: React.PropTypes.func.isRequired
    onClick: React.PropTypes.func.isRequired

  getInitialState: ->
    endorsed_at: @props.comment.endorsed_at
    deleted: false
    showDeleteModal: false

  closeDeleteModal: ->
    @setState({showDeleteModal:false})

  openDeleteModal: ->
    @setState({showDeleteModal:true})

  toggleEndorse: ->
    if @state.endorsed_at
      @setState({endorsed_at: 0})
      console.log("unendorse")
    else
      @setState({endorsed_at: moment(TimeStore.getNow()).format('YYYY-MM-DDTh:mm:ss.SSS')+"Z"})
      console.log("endorse")

  deleteOperations: ->
    @setState({showDeleteModal:false})
    @setState({deleted: true})

  confirmDeletion: ->
    @props.confirmDeletion(@props.comment)

  render: ->
    cPostDate = <Time date={@props.comment.post_date} format='concise'/>
    tooltipEndorse = <BS.Tooltip id="endorse-tooltip">Toggle Endorsement</BS.Tooltip>
    tooltipDelete = <BS.Tooltip id="endorse-tooltip">Delete Post</BS.Tooltip>
    iconAreaClassName = "icon-area"
    commentRowClassName = "comment-row"
    if @state.endorsed_at
      iconAreaClassName += " endorsed"

    if @state.deleted
      commentRowClassName += " deleted"

    <BS.Row className={commentRowClassName}>
      <BS.Col xs={2} sm={2} className="reply-prompt-col" onClick={@props.onClick}>
        <span className="reply-prompt">{"Reply to"}</span>
      </BS.Col>
      <BS.Col xs={7} sm={7} className='comment' onClick={@props.onClick}>
        <span className="comment-author">{@props.comment.author}{": "}</span>
        <span className="comment-text">{@props.comment.text}</span>
      </BS.Col>
      <BS.Col xs={2} sm={2} className="comment-post-date" onClick={@props.onClick}>
        {cPostDate}
      </BS.Col>
      <BS.Col xs={1} sm={1} className={iconAreaClassName}>
        <div className="icon-endorse-container" onClick={@toggleEndorse}>
          <BS.OverlayTrigger placement="top" overlay={tooltipEndorse}>
            <i className="icon icon-endorse"/>
          </BS.OverlayTrigger>
        </div>
        <div className="icon-delete-container" onClick={@openDeleteModal}>
          <BS.OverlayTrigger placement="top" overlay={tooltipDelete}>
            <i className="icon icon-delete"/>
          </BS.OverlayTrigger>
        </div>
        <BS.Modal className="delete-confirm-modal" show={@state.showDeleteModal} onHide={@closeDeleteModal}>
          <ModalHeader closeButton className="delete-confirm-header">
            <BS.Modal.Title>{"Confirm Deletion"}</BS.Modal.Title>
          </ModalHeader>
          <BS.Modal.Body className="delete-confirm-body">
            <BS.Row>
              <span>
                {"Are you sure you want to delete this comment?"}
              </span>
            </BS.Row>
          </BS.Modal.Body>
          <BS.Modal.Footer className="delete-confirm-footer">
            <BS.Button bsStyle="default" onClick={@closeDeleteModal}>
              {"Cancel"}
            </BS.Button>
            <BS.Button bsStyle="primary" onClick={@deleteOperations}>
              {"Confirm"}
            </BS.Button>
          </BS.Modal.Footer>
        </BS.Modal>
      </BS.Col>
    </BS.Row>
