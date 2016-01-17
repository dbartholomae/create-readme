DescriptionParser = require '../components/description.coffee'
os = require 'os'

describe "A DescriptionParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "should parse the description from package.json correctly", ->
    descriptionParser = new DescriptionParser()
    expect(descriptionParser.run pkg).to.eventually.equal "Automatically creates README.md based " +
                    "on package.json and other existing files."

  it "should accept an addition to the description as a String", ->
    addDesc = "And it uses its own package.json for testing, which definitely isn't good!"
    descriptionParser = new DescriptionParser(
      addDesc: addDesc
    )
    expect(descriptionParser.run pkg).to.eventually.equal "Automatically creates README.md based " +
                    "on package.json and other existing files." + os.EOL + os.EOL +
                    "And it uses its own package.json for testing, which definitely isn't good!"

  it "should accept an addition to the description as an array", ->
    addDesc = ["And it uses its own package.json ", "for testing, which definitely isn't good!"]
    descriptionParser = new DescriptionParser
      addDesc: addDesc
    expect(descriptionParser.run pkg).to.eventually.equal "Automatically creates README.md based " +
                    "on package.json and other existing files." + os.EOL + os.EOL +
                    "And it uses its own package.json for testing, which definitely isn't good!"
