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
    if @props.title
      <span className="title">{@props.title}</span>
    else
      <span className="date-range">
        <Time date={moment(@props.startAt).toDate()}/>
           &ndash;
        <Time date={moment(@props.endAt).toDate()}/>
      </span>

  renderPost: (post) ->
    <GenericPostRow courseId=@props.courseId key={post.id} post={post}/>

  render: ->
    <BS.Panel className={@props.className}>
      <div className="row labels">
        <BS.Col xs={12} sm={7}>{@renderTitle()}</BS.Col>
        <BS.Col xs={5} xsOffset={2} smOffset={0} sm={3} className='progress-label'>
          Author
        </BS.Col>
        <BS.Col xs={5} sm={2} className='due-at-label'>Text</BS.Col>
      </div>
      {_.map(@props.posts, @renderPost)}
    </BS.Panel>
