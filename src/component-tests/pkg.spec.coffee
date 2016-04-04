PkgParser = require '../components/pkg.coffee'

describe "A PkgParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "should parse pkg info correctly", ->
    pkgParser = new PkgParser()
    expect(pkgParser.run pkg).to.eventually.deep.equal
      name: pkg.name
      version: pkg.version
      private: pkg.private
      preferGlobal: pkg.preferGlobal

  it "should parse a differen pkg.json if asked", ->
    pkg = require '../../test-fixtures/package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"
    pkgParser = new PkgParser({ packagePath: './test-fixtures/package.json' })
    expect(pkgParser.run pkg).to.eventually.deep.equal
      name: pkg.name
      version: pkg.version
      private: pkg.private
      preferGlobal: pkg.preferGlobal
