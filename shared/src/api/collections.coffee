hash = require 'object-hash'
moment = require 'moment'
{observable, extendObservable, computed} = require 'mobx'

partial   = require 'lodash/partial'
every     = require 'lodash/every'
pick      = require 'lodash/pick'
trim      = require 'lodash/trim'
omit      = require 'lodash/omit'
omitBy    = require 'lodash/omitBy'
merge     = require 'lodash/merge'
some      = require 'lodash/some'
has       = require 'lodash/has'
flow      = require 'lodash/flow'
last      = require 'lodash/last'
size      = require 'lodash/size'
keys      = require 'lodash/keys'
memoize   = require 'lodash/memoize'
forEach   = require 'lodash/forEach'
isEmpty   = require 'lodash/isEmpty'
cloneDeep = require 'lodash/cloneDeep'
isString  = require 'lodash/isString'
isUndefined  = require 'lodash/isUndefined'

validateOptions = (requiredProperties...) ->
  (options) ->
    every(requiredProperties, partial(has, options))

hashWithArrays = partial(hash, partial.placeholder, {unorderedArrays: true})

makeHashWith = (uniqueProperties...) ->
  (objectToHash) ->
    hashWithArrays(pick(objectToHash, uniqueProperties...))

constructCollection = (context, makeItem, lookup, testing) ->
  context._cache = observable.map()
  context.make = makeItem
  context.lookup = memoize(lookup) or memoize(flow(makeItem, hashWithArrays))

  context

class Collection
  constructor: (makeItem, lookup) ->
    constructCollection(@, makeItem, lookup)

  set: (args...) =>
    @_cache.set(@lookup(args...), @make(args...))

  update: (args...) =>
    @_cache.set(@lookup(args...), merge(@_cache.get(args...), args...))

  load: (items) =>
    forEach items, @set

  get: (args...) =>
    cloneDeep(@_cache.get(@lookup(args...)))

  delete: (args...) =>
    @_cache.delete(@lookup(args...))
    true


class CollectionCached
  constructor: (makeItem, lookup) ->
    constructCollection(@, makeItem, lookup)

  update: (args...) =>
    @_cache.set(@lookup(args...), observable.array()) unless @_cache.has(@lookup(args...))
    @_cache.get(@lookup(args...)).push(@make(args...))

  get: (args...) =>
    flow(last, cloneDeep)(@_cache.get(@lookup(args...)))

  getAll: (args...) =>
    cloneDeep(@_cache.get(@lookup(args...)))

  getSize: (args...) =>
    size(@_cache.get(@lookup(args...))) or 0

  reset: (args...) =>
    @_cache.delete(@lookup(args...))
    true


# the combination of these should be unique
ROUTE_UNIQUES = ['subject', 'action']

# options will be stored by hash of ROUTE_UNIQUES
#
# routesSchema = [{
#   subject: 'exercises'
#   topic: '*' // optional, default
#   pattern: ''
#   method: 'GET'
#   action: 'fetch' // optional, defaults to method
#   baseUrl: // optional, will override API class default
#   onSuccess: -> // optional
#   onFail: -> // optional
#   headers: // optional
#   withCredentials: // option
# }]
METHODS_TO_ACTIONS =
  POST: 'create'
  GET: 'read'
  PATCH: 'update'
  DELETE: 'delete'
  PUT: 'modify'

makeRoute = (options = {}) ->
  # TODO throw errors
  # TODO look for validator lib, maybe even use React.PropTypes base/would be nice to
  #   validate that method is valid for example and not just exists.
  return options unless validateOptions('subject', 'pattern', 'method')(options)

  DEFAULT_ROUTE_OPTIONS =
    topic: '*'

  route = merge({}, DEFAULT_ROUTE_OPTIONS, options)
  route.action ?= METHODS_TO_ACTIONS[route.method]
  route.handledErrors ?= keys(route.errorHandlers) if route.errorHandlers

  route

class Routes extends Collection
  constructor: (routes = [], uniqueProperties = ROUTE_UNIQUES) ->
    hashRoute = makeHashWith(uniqueProperties...)
    lookup = flow(makeRoute, hashRoute)

    super(makeRoute, lookup)
    @load(routes)
    @

simplifyRequestConfig = (requestConfig) ->
  simpleRequest = pick(requestConfig, 'method', 'data', 'url', 'params')
  simpleRequest.url = simpleRequest.url.replace(requestConfig.baseURL, '') if requestConfig.baseURL
  simpleRequest.url = trim(simpleRequest.url, '/')

  if isEmpty(simpleRequest.data)
    simpleRequest = omit(simpleRequest, 'data')
  else if isString(simpleRequest.data)
    try
      simpleRequest.data = JSON.parse(simpleRequest.data)
    catch e

  simpleRequest.data = omitBy(simpleRequest.data, isUndefined) if simpleRequest.data

  simpleRequest

class XHRRecords
  constructor: ->
    hashRequestConfig = flow(simplifyRequestConfig, hashWithArrays)
    makeTime = ->
      moment()

    @_requests = new CollectionCached(makeTime, hashRequestConfig)
    @_responses = new CollectionCached(makeTime, hashRequestConfig)

    extendObservable(@,
      _pending: observable.map()
      _isBusy: computed () =>
        some(@_pending.values())
    )
    @_requests._cache.observe(({name}) =>
      @_pending.set(name, true)
    )
    @_responses._cache.observe(({name}) =>
      @_pending.set(name, !@_pending.get(name))
    )
    @

  queRequest: (requestConfig) =>
    @_requests.update(requestConfig)

  recordResponse: ({config}) =>
    @_responses.update(config)

  isPending: (requestConfig) =>
    if requestConfig
      @_pending.get(@_responses.lookup(requestConfig))
    else
      some @_requests._cache, (cachedRequests, requestKey) =>
        size(cachedRequests) > size(@_responses._cache[requestKey])

  getResponseTime: (requestConfig) =>
    @_requests.get(requestConfig).diff(@_responses.get(requestConfig))

window.size = size
utils = {validateOptions, hashWithArrays, makeHashWith, constructCollection, makeRoute, simplifyRequestConfig}

module.exports = {Collection, CollectionCached, Routes, XHRRecords, utils, METHODS_TO_ACTIONS}
