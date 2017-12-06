LabelManager = require('./label-manager')

module.exports =
class GlossariesProvider
  selector: '.meta.glossaries.latex'
  inclusionPriority: 2
  suggestionPriority: 3
  excludeLowerPriority: true

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
      rightLabel: result.prettyText
      leftLabel: result.type
      type: result.type
      description: result.description
      iconHTML: '<i class="icon-bookmark"></i>'

  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  dispose: ->
    @manager = []

  getPrefix: (editor, bufferPosition) ->

    regex = ///
            {([\w-]+)$ # macthing the prefix
            ///

    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

    # Match the regex to the line, and return the match
    line.match(regex)?[1] or ''
