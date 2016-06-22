CrudConfig, makeSimpleStore, extendConfig} = require './helpers'
{TimeStore} = require './time'
_ = require 'underscore'
moment = require 'moment'

StudentDashboardConfig = {
  _asyncStatusStats: {}

  hide:(taskId) ->
    @_asyncStatusStats[taskId] = 'hiding'

  hidden:(taskId) ->
    @_asyncStatusStats[taskId] = 'hidden'
    @emit("hidden", taskId)

  exports:

    isDeleted: (event) -> event.is_deleted

    
}

extendConfig(ForumConfig, new CrudConfig())
{actions, store} = makeSimpleStore(ForumConfig)
module.exports = {ForumActions:actions, ForumStore:store}
