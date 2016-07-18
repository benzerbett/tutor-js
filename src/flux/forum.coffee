{CrudConfig, makeSimpleStore, extendConfig} = require './helpers'
{TimeStore} = require './time'
_ = require 'underscore'
moment = require 'moment'

ForumConfig = {

  _saved: (obj, courseId) ->
    forum = @_get(courseId)

    if `obj.type=='post'`
      obj.id = forum.posts.length + 1
      obj.comments = []
      forum.posts.push(obj)

    if `obj.type =='comment'`
      obj.id = forum.posts[obj.postid-1].comments.length + 1
      obj.author= 'Johny Tran'
      forum.posts[obj.postid-1].comments.push(obj)

    return forum


  exports:

    isDeleted: (post) -> post.is_deleted

    topicTags: (courseId) ->
      data = @_get(courseId)
      topics = data.topics or []
    chapterTags: (courseId) ->
      data = @_get(courseId)
      chapters = data.chapters or []

    posts: (courseId) ->
      data = @_get(courseId)
      posts = data.posts or []

    postsByRecent: (courseId) ->
      posts = this.exports.posts.call(this, courseId)
      _.sortBy(posts, 'post_date').reverse()
}

extendConfig(ForumConfig, new CrudConfig())
{actions, store} = makeSimpleStore(ForumConfig)
module.exports = {ForumActions:actions, ForumStore:store}
