_ = require 'underscore'
flux = require 'flux-react'

{CrudConfig, makeSimpleStore, extendConfig} = require './helpers'

TaskStepConfig =

  _loaded: (obj, id) ->
    if not obj.task_id
      obj.task_id = @_local[id]?.task_id
    obj

  _saved: (obj, id) ->
    obj.task_id = @_local[id].task_id
    obj

  complete: (id) ->
    @_change(id, {is_completed: true})
    @emitChange()

  setAnswerId: (id, answer_id) ->
    @_change(id, {answer_id})
    @emitChange()

  setFreeResponseAnswer: (id, free_response) ->
    @_change(id, {free_response})
    @emitChange()

  loadRecovery: (id) ->
    @emitChange()

  loadedRecovery: (obj, id) ->
    @clearChanged()
    @emitChange()

  exports:
    isAnswered: (id) ->
      step = @_get(id)
      isAnswered = true
      if step.type is 'exercise'
        unless step.answer_id
          isAnswered = false
      isAnswered

    getTaskId: (id) ->
      step = @_get(id)
      step.task_id

    getFreeResponse: (id) ->
      step = @_get(id)
      step.free_response
    getAnswerId: (id) ->
      step = @_get(id)
      step.answer_id


extendConfig(TaskStepConfig, new CrudConfig())
{actions, store} = makeSimpleStore(TaskStepConfig)
module.exports = {TaskStepActions:actions, TaskStepStore:store}
