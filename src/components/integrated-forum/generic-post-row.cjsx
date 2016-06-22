React    = require 'react'
BS       = require 'react-bootstrap'
PostRow = require './post-row'

# Represents a generic event, such as a Holiday.
# It's the fallback renderer for events that do not
# have a designated renderer
module.exports = React.createClass
  displayName: 'GenericPostRow'

  propTypes:
    post: React.PropTypes.object.isRequired
    courseId: React.PropTypes.string.isRequired

  render: ->
    <PostRow feedback='' {...@props} className='generic'>
        {@props.post.title}
    </PostRow>
