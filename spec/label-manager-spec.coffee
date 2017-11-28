LabelManager = require '../lib/label-manager'

describe "When the LabelManger gets initialized", ->
  manager = null

  beforeEach ->
    atom.project.setPaths([__dirname])
    manager = new LabelManager()
    waitsForPromise ->
      manager.initialize()

  it "is not null", ->
    expect(manager).not.toEqual(null)

  it "add the project dir to the databaseFiles", ->
    expect(manager.databaseFiles.size).toEqual(1)
    expect(manager.databaseFiles.has(__dirname))

  it "loads parses the gldsdefs file in the project dir", ->
    expect(Object.keys(manager.database).length).toEqual(3)
    expect(manager.database['BHKW'].description).toEqual('Blockheizkraftwerk')
    expect(manager.database['BHKW'].text).toEqual('BHKW')
    expect(manager.database['BHKW'].label).toEqual('BHKW')
    expect(manager.database['BHKW'].type).toEqual('acronym')

  it "can search with prefixes in the database", ->
    result  = manager.searchForPrefixInDatabase('BHKW')
    expect(result[0].label).toEqual('BHKW')

  it "convertes Latex to Unicode", ->
    expect(manager.database['Spannungswinkel'].prettyText).toEqual('δ')
