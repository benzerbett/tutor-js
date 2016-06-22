React    = require 'react'
BS       = require 'react-bootstrap'
PostRow = require './post-row'

module.exports = React.createClass
  displayName: 'GenericPostRow'

  propTypes:
    post: React.PropTypes.object.isRequired
    courseId: React.PropTypes.string.isRequired

  render: ->
    <PostRow feedback='' {...@props} className='generic'>
        {@props.post.title}
    </PostRow>
