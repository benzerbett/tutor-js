React  = require 'react'
BS     = require 'react-bootstrap'
Time   = require '../time'
moment = require 'moment'
{TimeStore} = require '../../flux/time'
moment = require 'moment-timezone'

{ForumActions, ForumStore} = require '../../flux/forum'
classnames = require 'classnames'
FormGroup = require 'react-bootstrap/lib/FormGroup'
FormControl= require 'react-bootstrap/lib/FormControls'

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
    title = @state.title.trim().replace(/\n\s*\n/g, '\n')
    text = @state.text.trim().replace(/\n\s*\n/g, '\n')
    @props.onPostSubmit({
        type: 'post',
        author: 'Johny Tran',
        text: text,
        postDate: moment(TimeStore.getNow()).format('YYYY-MM-DDTh:mm:ss.SSS')+"Z",
        title: title,
        status: "active"
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
      <BS.Row>
          <div class = "form-group">
            <label className="text-label">{"Tags:"}</label>
            <select class = "form-control">
               <option>Chapter1</option>
               <option>Chapter2</option>
               <option>Chapter3</option>
               <option>Chapter4</option>
               <option>Chapter5</option>
            </select>
          </div>
      </BS.Row>

      <BS.Row className="post-submit-row">
          <BS.Button type="submit" bsStyle="primary" className="post-submit-button">{"Submit"}</BS.Button>
      </BS.Row>
    </form>
