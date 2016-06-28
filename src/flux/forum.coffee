{CrudConfig, makeSimpleStore, extendConfig} = require './helpers'
{TimeStore} = require './time'
_ = require 'underscore'
moment = require 'moment'

ForumConfig = {

  _saved: (obj, courseId) ->
    forum = @_get(courseId)
    obj.id = forum.posts.length + 1
    forum.posts.push(obj)

    return forum


  exports:

    isDeleted: (post) -> post.is_deleted

    posts: (courseId) ->
      data = @_get(courseId)
      posts = data.posts or []
}

extendConfig(ForumConfig, new CrudConfig())
{actions, store} = makeSimpleStore(ForumConfig)
module.exports = {ForumActions:actions, ForumStore:store}
