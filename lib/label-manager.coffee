{watchPath} =  require 'atom'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
Fuse = require 'fuse.js'
glob = require 'glob'
path = require 'path'

module.exports =
class LabelManager
  fuseOptions =
    shouldSort: true,
    threshold: 0.6,
    location: 0,
    distance: 100,
    maxPatternLength: 32,
    minMatchCharLength: 1,
    keys: ["label"]

  destroy: () ->
    @disposables.dispose()

  constructor: ->
    @disposables = new CompositeDisposable
    @databaseFiles = new Set()
    @database = {}
    @fuse = new Fuse(Object.values(@database),fuseOptions)

    @addDatabaseFiles()
    @registerForDatabaseChanges()
    @updateDatabase()

  addDatabaseFiles: ->
    for ppath in atom.project.getPaths()
      files = glob.sync(path.join(ppath, '*.glsdefs'))
      for file in files
        @databaseFiles.add(path.normalize(file))

  searchForPrefixInDatabase: (prefix) ->
    @fuse.search(prefix)

  updateDatabase: ->
    @database = {}
    regex = ///
            \\gls@defglossaryentry{([\w:-]+)} #label
            [\w\W]*? # eveything
            type={(.*?)},% # type
            [\w\W]*? # eveything
            text={(.*?)},% # text
            [\w\W]*? # eveything
            description={(.*?)},% # description
            ///g

    @databaseFiles.forEach (file) =>
      fs.readFile file, 'utf8', (err, data) =>
        throw err if  err
        match = regex.exec data
        while match
          entry =
            label: match[1]
            type: match[2]
            text: match[3]
            description: match[4]
          @database[match[1]] = entry
          match =  regex.exec data
        @fuse = new Fuse(Object.values(@database),fuseOptions)

  registerForDatabaseChanges: ->
    watcher = atom.project.onDidChangeFiles  (events) =>
      events = events.filter (e) -> /glsdefs$/.test(e["path"])
      for e in events
        switch e.action
          when "modified"
            @databaseFiles.add(e.path)
          when "created"
            @databaseFiles.add(e.path)
          when "deleted"
            @databaseFiles.delete(e.path)
      if events.length > 0
        @updateDatabase()
    @disposables.add watcher
