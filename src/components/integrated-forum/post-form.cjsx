React  = require 'react'
BS     = require 'react-bootstrap'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'
Time   = require '../time'
FormGroup = require 'react-bootstrap/lib/FormGroup'

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
    <form className="commentForm" onSubmit={this.handleSubmit} style={display: "inline"}>
        <br/>
        Title:
        <input
          type="text"
          placeholder="Title"
          value= {@state.title}
          onChange={@handleTitleChange}
        />
        <br/>
        <br/>
        Text:
        <input
          type="text"
          placeholder="Text"
          value={@state.text}
          onChange={@handleTextChange}
          style={width: '200px',height :'50px'}
        />
        <br/>
        <br/>
        <FormGroup/>



        <input type="submit" value="Post" />
    </form>
