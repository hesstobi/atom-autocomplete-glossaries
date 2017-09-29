{watchPath} =  require 'atom'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
fuse = require 'fuse'


module.exports =
class LabelManager
  @fuseOptions =
    shouldSort: true,
    threshold: 0.6,
    location: 0,
    distance: 100,
    maxPatternLength: 32,
    minMatchCharLength: 1,
    keys:
      "label"



  destroy: () ->
    @disposables.dispose()

  constructor: ->
    @disposables = new CompositeDisposable
    @databaseFiles = ['U:\\Documents\\Dissertation\\Dokument\\DissersationHess.glsdefs']
    @database = []
    @fuse = new Fuse(@database,@fuseOptions)

  searchForPrefixInDatabase: (prefix) ->
    fuse.search(prefix)

  updateDatabase: ->
    @database = []
    regex = ///
            \\gls@defglossaryentry{([\w:-]+)} #label
            [\w\W]*? # eveything
            type={(.*?)},% # type
            [\w\W]*? # eveything
            text={(.*?)},% # text
            [\w\W]*? # eveything
            description={(.*?)},% # description
            ///g

    for file in @databaseFiles
      fs.readFile file, 'utf8', (err, data) =>
        throw err if  err
        match = regex.exec data
        while match
          entry =
            label: match[1]
            type: match[2]
            text: match[3]
            description: match[4]
          @database.push entry
          match =  regex.exec data
        console.log(@database)
        @fuse = new Fuse(@database,@fuseOptions)

  registerForDatabaseChanges: ->
    watcher = atom.project.onDidChangeFiles  (events) ->
      console.log(events)
    @disposables.add watcher

#           {[
#   {
#     "action": "", // one of "modified", "created", "deleted", or "renamed"
#     "oldPath": "", // undefined unless type is "renamed," in which case it holds the former name of the entry
#     "path": "" // absolute path to the changed entry
#   }
# ]}
