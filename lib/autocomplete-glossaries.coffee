configSchema = require './config'

module.exports =
  config: configSchema
  provider: null

  activate: ->

  deactivate: ->
    @provider = null

  provide: ->
    unless @provider?
      GlossariesProvider = require('./glossaries-provider')
      @provider = new GlossariesProvider()

    @provider
