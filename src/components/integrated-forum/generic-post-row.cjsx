###
THIS FILE IS DEPRECATED AND NO LONGER USED in favor of post-row with a className property
###


React    = require 'react'
BS       = require 'react-bootstrap'
PostRow = require './post-row'

module.exports = React.createClass
  displayName: 'GenericPostRow'

  propTypes:
    post: React.PropTypes.object.isRequired
    courseId: React.PropTypes.string.isRequired

  render: ->
    <PostRow {...@props} className='generic'>
      {@props.post.title}
    </PostRow>
