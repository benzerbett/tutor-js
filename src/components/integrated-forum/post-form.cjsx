React  = require 'react'
BS     = require 'react-bootstrap'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'
Time   = require '../time'
FormGroup = require 'react-bootstrap/lib/FormGroup'
FC= require 'react-bootstrap/lib/FormControls'


{ForumActions, ForumStore} = require '../../flux/forum'
EventInfoIcon = require '../student-dashboard/event-info-icon'
{Instructions} = require '../task/details'
classnames = require 'classnames'

module.exports = React.createClass
  displayName: 'PostForm'

  propTypes:
    onCommentSubmit: React.PropTypes.func.isRequired
    # feedback:  React.PropTypes.string.isRequired
  getInitialState: ->
    title: ''
    text: ''

  handleTitleChange: (e)->
    @setState({title: e.target.value})
  handleTextChange: (e)->
    @setState({text: e.target.value})
  handleSubmit: (submitEvent) ->
    submitEvent.preventDefault()

    title = @state.title.trim()
    text = @state.text.trim()
    @props.onCommentSubmit({author: 'Johny Tran', text: text,postDate:'2016-06-23T11:45:30.565Z',title:title })
    @setState({title: '', text: ''})

  render: ->
    <form className="post-form" onSubmit={this.handleSubmit}>
        <BS.Row className="post-text-row">
          <label>Title: </label>
          <input
            type="text"
            placeholder="Title"
            value= {@state.title}
            onChange={@handleTitleChange}
          />
        </BS.Row>

        <BS.Row>
          <label>Text: </label>
          <textarea class="form-control" id="comment-input" placeholder="text" onChange={@handleTextChange}>
          </textarea>
        </BS.Row>



        <BS.Col xs={1} sm={1} md={1} mdOffset = {8} xsOffset={8} smOffset={9} className="post-submit">
          <BS.Button type = "submit" bsStyle="primary" className="comment-submit-button">Submit</BS.Button>
        </BS.Col>
    </form>
