proxyquire = require 'proxyquire'
mockFs = require 'mock-fs'

describe "A DocsParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "returns a rawgit url if the doc file exists", ->
    DocsParser = proxyquire '../components/docs.coffee',
      fs: mockFs.fs
        'doc/index.html': "Some documentation. Oh no, where's the html?"
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually
    .deep.equal 'https://rawgit.com/dbartholomae/readme-creator/master/doc/index.html'

  it "returns null if the doc file doesn't exist", ->
    DocsParser = proxyquire '../components/docs.coffee',
      fs: mockFs.fs()
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually.deep.equal null

  it "returns null if it isn't a git repository", ->
    pkg.git = null
    DocsParser = proxyquire '../components/docs.coffee',
      'doc/index.html': "Some documentation. Oh no, where's the html?"
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually.deep.equal null

  it "accepts different doc files", ->
    pkg.directories.doc = 'docs'
    DocsParser = proxyquire '../components/docs.coffee',
      fs: mockFs.fs
        'docs/index.htm': "Some documentation. Oh no, where's the html?"
    docsParser = new DocsParser
      docFile: 'index.htm'
    expect(docsParser.run pkg).to.eventually
    .deep.equal 'https://rawgit.com/dbartholomae/readme-creator/master/docs/index.htm'

