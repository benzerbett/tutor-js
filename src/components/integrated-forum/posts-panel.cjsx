React = require 'react'
BS    = require 'react-bootstrap'
Time  = require '../time'
moment = require 'moment'
ReadingRow      = require '../student-dashboard/reading-row'
HomeworkRow     = require '../student-dashboard/homework-row'
ExternalRow     = require '../student-dashboard/external-row'
EventTaskRow        = require '../student-dashboard/event-task-row'
PostRow        = require './post-row'
GenericPostRow = require './generic-post-row'
_ = require 'underscore'

module.exports = React.createClass
  displayName: 'PostsPanel'

  propTypes:
    posts:   React.PropTypes.array.isRequired
    courseId: React.PropTypes.string.isRequired
    startAt:  React.PropTypes.object
    endAt:    React.PropTypes.object
    limit:    React.PropTypes.number
    title:    React.PropTypes.string
    className: React.PropTypes.string

  renderTitle: ->
    <span className="title-label">{@props.title}</span>

  renderPost: (post) ->
    <GenericPostRow courseId=@props.courseId key={post.id} post={post}/>

  render: ->
    <BS.Panel className={@props.className}>
      
      <div className="row labels">
        <BS.Col xs={10} xsOffset={2} smOffset={1} sm={6} className='title-label'>
          Title
        </BS.Col>
        <BS.Col xs={5} sm={3} className='author-label'>
          Author
        </BS.Col>
        <BS.Col xs={5} sm={2} className='post-date-label'>Text</BS.Col>
      </div>
      {_.map(@props.posts, @renderPost)}
    </BS.Panel>
