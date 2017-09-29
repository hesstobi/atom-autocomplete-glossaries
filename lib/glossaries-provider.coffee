LabelManager = require('./label-manager')

module.exports =
class GlossariesProvider
  selector: '.text.tex.latex'
  disableForSelector: '.comment'
  inclusionPriority: 2
  suggestionPriority: 2
  excludeLowerPriority: true

  constructor: ->
    @showIcon = atom.config.get('autocomplete-plus.defaultProvider') is 'Symbol'
    @manager = new LabelManager()
    @manager.updateDatabase()

  getSuggestions: ({editor, bufferPosition}) ->
    prefix = @getPrefix(editor, bufferPosition)
    return unless prefix?.length
    new Promise (resolve) ->
      suggestion =
        text: 'someText'
        replacementPrefix: prefix
        leftLabel: 'list'
        type: 'value'
        description: 'the description'
      resolve([suggestion])

  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  dispose: ->

  getPrefix: (editor, bufferPosition) ->

    cmdprefixes = atom.config.get "autocomplete-glossaries.commandPrefixes"
    cmdprefixes = cmdprefixes.join '|'
    regex = ///
            \\(#{cmdprefixes}) # group for commands prefixes
            \w* # command can be followd by suffix
            (\<[\\\w-]*\>)? # optional paramters
            (\[[\\\w-]*\])? # optional paramters
            {([\w-]+)$ # macthing the prefix
            ///

    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

    # Match the regex to the line, and return the match
    line.match(regex)?[4] or ''


  findSuggestionsForPrefix: (prefix) ->
    suggestions = []
    for snippetPrefix, snippet of snippets
      continue unless snippet and snippetPrefix and prefix and firstCharsEqual(snippetPrefix, prefix)
      suggestions.push
        iconHTML: if @showIcon then undefined else false
        type: 'snippet'
        text: snippet.prefix
        replacementPrefix: prefix
        rightLabel: snippet.name
        rightLabelHTML: snippet.rightLabelHTML
        leftLabel: snippet.leftLabel
        leftLabelHTML: snippet.leftLabelHTML
        description: snippet.description
        descriptionMoreURL: snippet.descriptionMoreURL

    suggestions.sort(ascendingPrefixComparator)
    suggestions


ascendingPrefixComparator = (a, b) -> a.text.localeCompare(b.text)

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
