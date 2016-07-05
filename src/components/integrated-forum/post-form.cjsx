React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
moment = require 'moment'

{ForumActions, ForumStore} = require '../../flux/forum'
classnames = require 'classnames'

module.exports = React.createClass
  displayName: 'PostForm'

  propTypes:
    onPostSubmit: React.PropTypes.func.isRequired

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
    @props.onPostSubmit({
        author: 'Johny Tran', 
        text: text,
        post_date: {'2016-06-23T21:50:09.565Z'},
        title: title
      }
    )
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

      <BS.Row className="post-submit-row">
          <BS.Button type="submit" bsStyle="primary" className="post-submit-button">{"Submit"}</BS.Button>
      </BS.Row>
    </form>
