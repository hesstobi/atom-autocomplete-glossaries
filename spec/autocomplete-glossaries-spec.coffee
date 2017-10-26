describe "Glossaries Autocompletions Package", ->
  {workspaceElement} = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    waitsForPromise -> atom.packages.activatePackage('autocomplete-glossaries')

   describe 'when the autocomplete-glossaries:show-database-info event is triggered', ->
     it 'shows a notification', ->
       atom.commands.dispatch(workspaceElement, 'autocomplete-glossaries:show-database-info')
       noti = atom.notifications.getNotifications()
       expect(noti).toHaveLength 1
       expect(noti[0].message).toEqual "Autocomplete Glossaries Database Info"
       expect(noti[0].type).toEqual "info"
