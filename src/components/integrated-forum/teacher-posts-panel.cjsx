React = require 'react'
BS    = require 'react-bootstrap'
moment = require 'moment'
TeacherPostRow = require './teacher-post-row'
_ = require 'underscore'

module.exports = React.createClass
  displayName: 'PostsPanel'

  propTypes:
    posts:   React.PropTypes.array.isRequired
    courseId: React.PropTypes.string.isRequired
    postDate: React.PropTypes.object
    limit:    React.PropTypes.number
    title:    React.PropTypes.string
    className: React.PropTypes.string

  renderTitle: ->
    <span className="title-label">{@props.title}</span>

  renderPost: (post) ->
    <TeacherPostRow courseId={@props.courseId} post={post} className={post.status}>
      {post.title}
    </TeacherPostRow>

  render: ->
    <BS.Panel className={@props.className}>
      {_.map(@props.posts, @renderPost)}
    </BS.Panel>
