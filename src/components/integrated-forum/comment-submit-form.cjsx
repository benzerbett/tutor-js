React  = require 'react'
BS     = require 'react-bootstrap'

module.exports = React.createClass
  displayName: 'CommentSubmitForm'

  propTypes:
    handleSubmit: React.PropTypes.func.isRequired
    tag: React.PropTypes.string.isRequired

  getInitialState: ->
    comment: @props.tag

  componentWillReceiveProps: (nextProps) ->
    trimmedTag = @state.comment.replace(/^@\w+:\W?/, '')
    @setState(comment: nextProps.tag + trimmedTag)


  autoGrow: (event) ->
    @setState({comment: event.target.value})
    event.target.style.height = "5px"
    event.target.style.height = (event.target.scrollHeight)+"px"

  handleSubmit: (submitEvent) ->
    @props.handleSubmit(submitEvent, @state.comment or '')
    @setState({comment: ''})

  render: ->
    <form onSubmit={@handleSubmit}>
      <BS.Row className="comment-form">
        <BS.Col xs={7} sm={7} xsOffset={2} smOffset={2} className="comment-box">
            <textarea
              className="comment-input"
              placeholder="Add Comment..."
              value={@state.comment}
              onChange={@autoGrow}>
            </textarea>
        </BS.Col>
        <BS.Col xs={2} sm={2} className="comment-submit">
          <BS.Button type="submit" bsStyle="primary" className="comment-submit-button">Comment</BS.Button>
        </BS.Col>
      </BS.Row>
    </form>