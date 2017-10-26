{ CompositeDisposable } = require 'atom'

configSchema = require './config'

module.exports =
  config: configSchema
  provider: null
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable()

    # Add command to Atom
    this.subscriptions.add(atom.commands.add('atom-workspace',
      {'autocomplete-glossaries:show-database-info': () => @showDatabaseInfo()}))


  # Get Database Informations
  showDatabaseInfo: ->
    message = "Autocomplete Glossaries Database Info"
    options = {
      'dismissable': true
      'icon': 'database'
    }

    if @provider?
      db = @provider.manager.database

      if Object.keys(db).length
        num = Object.keys(db).length
        groups = {}
        for k,v of db
          if !(v.type of groups)
            groups[v.type] = 0
          groups[v.type] = groups[v.type]+1
        numGroups = Object.keys(groups).length

        list = ''
        for k,v of groups
          list += "* #{k}: `#{v}`\n"

        options['description'] = """
          There are `#{num}` entries in the glossaries with `#{numGroups}`
          different types:

          #{list}
        """
      else
        options['description'] = '''
          There are no glossaries entries in the database.
          Did you have an `glsdefs` file in your project directory?
          If not, move your glossaries entries definition to the document
          enviroment.
        '''
    else
      options['description'] = "Provider not initialized. Did you "

    atom.notifications.addInfo(message,options)

  deactivate: ->
    @provider = null
    @subscriptions.dispose()

  provide: ->
    unless @provider?
      GlossariesProvider = require('./glossaries-provider')
      @provider = new GlossariesProvider()

    @provider
