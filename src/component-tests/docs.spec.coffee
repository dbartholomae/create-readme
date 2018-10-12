mockFs = require 'mock-fs'
DocsParser = require '../components/docs.coffee'

describe "A DocsParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  afterEach ->
    mockFs.restore()

  it "returns a rawgit url if the doc file exists", ->
    mockFs
      'doc/index.html': "Some documentation. Oh no, where's the html?"
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually
    .deep.equal 'https://rawgit.com/dbartholomae/readme-creator/master/doc/index.html'

  it "returns null if the doc file doesn't exist", ->
    mockFs()
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually.deep.equal null

  it "returns null if it isn't a git repository", ->
    pkg.git = null
    mockFs
      'doc/index.html': "Some documentation. Oh no, where's the html?"
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually.deep.equal null

  it "accepts different doc files", ->
    pkg.directories.doc = 'docs'
    mockFs
      'docs/index.htm': "Some documentation. Oh no, where's the html?"
    docsParser = new DocsParser
      docFile: 'index.htm'
    expect(docsParser.run pkg).to.eventually
    .deep.equal 'https://rawgit.com/dbartholomae/readme-creator/master/docs/index.htm'

