_ = require 'underscore'

module.exports =
  getInitialState: ->
    sectionSeparator: '.'
    skipZeros: true

  sectionFormat: (section, separator) ->
    # prevent mutation
    section = _.clone(section)
    # ignore 0 in chapter sections
    section.pop() if @state.skipZeros and _.last(section) is 0

    if section instanceof Array
      section.join(separator or @state.sectionSeparator)
    else
      section
