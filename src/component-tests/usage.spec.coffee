proxyquire = require 'proxyquire'
mockFs = require 'mock-fs'

describe "A UsageParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "returns examples parsed correctly from all files in the examples directory", ->
    UsageParser = proxyquire '../components/usage.coffee',
      fs: mockFs.fs
        'examples/example.js': 'require("../");'
        'examples/example.coffee': "require '../'"
        'examples/example.sh': "readme-creator -s"

    usageParser = new UsageParser()
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require 'readme-creator'"
        }
        {
          lang: 'javascript'
          content: "require('readme-creator');"
        }
        {
          lang: 'sh'
          content: 'readme-creator -s'
        }
      ]
      description: ''

  it "accepts additional usage text", ->
    UsageParser = proxyquire '../components/usage.coffee',
      fs: mockFs.fs
        'examples/example.js': 'require("../");'
        'examples/example.coffee': "require '../'"
        'examples/example.sh': "readme-creator -s"

    usageParser = new UsageParser
      addUsage: 'This should be useful'
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require 'readme-creator'"
        }
        {
          lang: 'javascript'
          content: "require('readme-creator');"
        }
        {
          lang: 'sh'
          content: 'readme-creator -s'
        }
      ]
      description: 'This should be useful'

  it "looks in the correct directory", ->
    pkg.directories.example = 'ex'
    UsageParser = proxyquire '../components/usage.coffee',
      fs: mockFs.fs
        'ex/example.js': 'require("../");'
        'ex/example.coffee': "require '../'"
        'ex/example.sh': "readme-creator -s"

    usageParser = new UsageParser
      addUsage: 'This should be useful'
    expect(usageParser.run pkg).to.eventually.deep.equal
      examples: [
        {
          lang: 'coffeescript'
          content: "require 'readme-creator'"
        }
        {
          lang: 'javascript'
          content: "require('readme-creator');"
        }
        {
          lang: 'sh'
          content: 'readme-creator -s'
        }
      ]
      description: 'This should be useful'

  it "allows to disable replacements", ->
    pkg.directories.example = 'ex'
    UsageParser = proxyquire '../components/usage.coffee',
      fs: mockFs.fs
        'ex/example.js': 'require("../");'
        'ex/example.coffee': "require '../'"
        'ex/example.sh': "readme-creator -s"

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
          content: 'readme-creator -s'
        }
      ]
      description: ''

  it "returns null if there are neither examples nor added usage text", ->
    UsageParser = proxyquire '../components/usage.coffee',
      fs: mockFs.fs()

    usageParser = new UsageParser()
    expect(usageParser.run pkg).to.eventually.equal null
