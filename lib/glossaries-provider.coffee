LabelManager = require('./label-manager')

module.exports =
class GlossariesProvider
  selector: '.text.tex.latex'
  disableForSelector: '.comment'
  inclusionPriority: 2
  suggestionPriority: 3
  excludeLowerPriority: false

  constructor: ->
    @manager = new LabelManager()
    @manager.initialize()

  getSuggestions: ({editor, bufferPosition}) ->
    prefix = @getPrefix(editor, bufferPosition)
    return unless prefix?.length
    new Promise (resolve) =>
      results = @manager.searchForPrefixInDatabase(prefix)
      suggestions = []
      for result in results
        suggestion = @suggestionForResult(result, prefix)
        suggestions.push suggestion
      resolve(suggestions)

  suggestionForResult: (result, prefix) ->
    suggestion =
      text: result.label
      replacementPrefix: prefix
      rightLabel: result.text
      leftLabel: result.type
      type: result.type
      description: result.description
      iconHTML: '<i class="icon-bookmark"></i>'

  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  dispose: ->
    @manager = []

  getPrefix: (editor, bufferPosition) ->

    cmdprefixes = atom.config.get "autocomplete-glossaries.commandPrefixes"
    cmdprefixes = cmdprefixes.join '|'
    regex = ///
            \\(#{cmdprefixes}) # group for commands prefixes
            \w* # command can be followd by suffix
            (\<[\\\w-]*\>)? # optional paramters
            (\[[\\\w-]*\])? # optional paramters
            {([\w-]+)$ # macthing the prefix
            ///i

    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

    # Match the regex to the line, and return the match
    line.match(regex)?[4] or ''
