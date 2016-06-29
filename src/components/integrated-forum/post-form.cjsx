React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'

{ForumActions, ForumStore} = require '../../flux/forum'
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
    <form className="post-form" onSubmit={@handleSubmit}>
      <BS.Row className="title-row">
        <label className="title-label">{"Title:"}</label>
        <textarea
          className="post-form-title"
          placeholder="Title"
          value= {@state.title}
          onChange={@handleTitleChange}>
        </textarea>
      </BS.Row>

      <BS.Row className="text-row">
        <label className="text-label">{"Text:"}</label>
        <textarea 
          className="post-form-text"
          placeholder="Text" 
          onChange={@handleTextChange}>
        </textarea>
      </BS.Row>

      <BS.Row>
        <BS.Col xs={2} sm={2} xsOffset={9} smOffset={9} className="post-submit">
          <BS.Button type="submit" bsStyle="primary" className="post-submit-button">{"Submit"}</BS.Button>
        </BS.Col>
      </BS.Row>
    </form>
