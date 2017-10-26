describe "Glossaries Autocompletions", ->
  [editor, provider] = []

  getCompletions = ->
    cursor = editor.getLastCursor()
    bufferPosition = cursor.getBufferPosition()
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    # https://github.com/atom/autocomplete-plus/blob/9506a5c5fafca29003c59566cfc2b3ac37080973/lib/autocomplete-manager.js#L57
    prefix = /(\b|['"~`!@#$%^&*(){}[\]=+,/?>])((\w+[\w-]*)|([.:;[{(< ]+))$/.exec(line)?[2] ? ''
    request =
      editor: editor
      bufferPosition: bufferPosition
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
    provider.getSuggestions(request)

  checkSuggestion = ->
    waitsForPromise ->
      getCompletions().then (values) ->
        expect(values.length).toBeGreaterThan 0
        expect(values[0].text).toEqual 'BHKW'

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('autocomplete-glossaries')
    waitsForPromise -> atom.packages.activatePackage('language-latex')

    runs ->
      provider = atom.packages.getActivePackage('autocomplete-glossaries').mainModule.provide()

    atom.project.setPaths([__dirname])
    waitsForPromise -> atom.workspace.open('test.tex')
    waitsFor -> Object.keys(provider.manager.database).length > 0
    runs ->
      editor = atom.workspace.getActiveTextEditor()

  it "returns no completions when not at the start of a tag", ->
    editor.setText('')
    expect(getCompletions()).not.toBeDefined()

    editor.setText('d')
    editor.setCursorBufferPosition([0, 0])
    expect(getCompletions()).not.toBeDefined()
    editor.setCursorBufferPosition([0, 1])
    expect(getCompletions()).not.toBeDefined()

  it "has no completions for prefix without first letter", ->
    editor.setText('\\gls{')
    expect(getCompletions()).not.toBeDefined()

  it "has completions for prefix starting with the first letter", ->
    editor.setText('\\gls{B')
    checkSuggestion()

  it "has completions for prefix variations", ->
    editor.setText('\\glspl{B')
    checkSuggestion()

  it "has completions for prefix with uppercase first letter", ->
    editor.setText('\\Gls{B')
    checkSuggestion()

  it "supports different prefixes by config", ->
    atom.config.set "autocomplete-glossaries.commandPrefixes", ['sym']
    editor.setText('\\sym{B')
    checkSuggestion()

  it "supports multiple prefixes by config", ->
    atom.config.set "autocomplete-glossaries.commandPrefixes", ['gls', 'sym']
    editor.setText('\\sym{B')
    checkSuggestion()
