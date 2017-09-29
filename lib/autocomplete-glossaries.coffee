configSchema = require './config'

module.exports =
  config: configSchema
  provider: null

  activate: ->

  deactivate: ->
    @provider = null
    @manager = null

  provide: ->
    unless @provider?
      GlossariesProvider = require('./glossaries-provider')
      @provider = new GlossariesProvider()

    @provider
