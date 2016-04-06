mockFs = require 'mock-fs'
UsageParser = require '../components/usage.coffee',

describe "A UsageParser", ->
  pkg = null

  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "create-readme"
      branch: "master"

  afterEach ->
    mockFs.restore()

  it "returns examples parsed correctly from all files in the examples directory", ->
    mockFs
      'examples/example.js': 'require("../");'
      'examples/example.coffee': "require '../'"
      'examples/example.sh': "create-readme -s"

    usageParser = new UsageParser()
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require 'create-readme'"
        }
        {
          lang: 'javascript'
          content: "require('create-readme');"
        }
        {
          lang: 'sh'
          content: 'create-readme -s'
        }
      ]
      description: ''

  it "accepts additional usage text", ->
    mockFs
      'examples/example.js': 'require("../");'
      'examples/example.coffee': "require '../'"
      'examples/example.sh': "create-readme -s"

    usageParser = new UsageParser
      addUsage: 'This should be useful'
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require 'create-readme'"
        }
        {
          lang: 'javascript'
          content: "require('create-readme');"
        }
        {
          lang: 'sh'
          content: 'create-readme -s'
        }
      ]
      description: 'This should be useful'

  it "looks in the correct directory", ->
    pkg.directories.example = 'ex'
    mockFs
      'ex/example.js': 'require("../");'
      'ex/example.coffee': "require '../'"
      'ex/example.sh': "create-readme -s"

    usageParser = new UsageParser
      addUsage: 'This should be useful'
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require 'create-readme'"
        }
        {
          lang: 'javascript'
          content: "require('create-readme');"
        }
        {
          lang: 'sh'
          content: 'create-readme -s'
        }
      ]
      description: 'This should be useful'

  it "allows to disable replacements", ->
    pkg.directories.example = 'ex'
    mockFs
      'ex/example.js': 'require("../");'
      'ex/example.coffee': "require '../'"
      'ex/example.sh': "create-readme -s"

    usageParser = new UsageParser
      replaceReferences: false
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require '../'"
        }
        {
          lang: 'javascript'
          content: 'require("../");'
        }
        {
          lang: 'sh'
          content: 'create-readme -s'
        }
      ]
      description: ''

  it "returns null if there are neither examples nor added usage text", ->
    mockFs()

    usageParser = new UsageParser()
    expect(usageParser.run {}).to.eventually.equal null
