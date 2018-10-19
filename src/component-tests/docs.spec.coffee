DocsParser = require '../components/docs.coffee'

describe "A DocsParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "returns a GitHub Pages url if the doc directory is set correctly", ->
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually
    .deep.equal 'https://dbartholomae.github.io/readme-creator/'

  it "returns null if the doc directory isn't set", ->
    pkg.directories.doc = null
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually.deep.equal null

  it "returns null if it isn't a git repository", ->
    pkg.git = null
    docsParser = new DocsParser()
    expect(docsParser.run pkg).to.eventually.deep.equal null
