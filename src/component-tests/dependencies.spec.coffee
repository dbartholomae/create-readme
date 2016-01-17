DependencyParser = require '../components/dependencies.coffee'

describe "A DependencyParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "should parse dependencies correctly", ->
    pkg.dependencies = { 'bluebird': '3.1.1' }
    pkg.devDependencies = {}
    dependencyParser = new DependencyParser()
    expect(dependencyParser.run pkg).to.eventually.deep.equal
      dep: [{
        name: 'bluebird'
        url: 'https://github.com/petkaantonov/bluebird'
        desc: 'Full featured Promises/A+ implementation with exceptionally good performance'
      }]
      dev: []

  it "should parse devDependencies correctly", ->
    pkg.dependencies = {}
    pkg.devDependencies = { 'npm-build-tools': '*' }
    dependencyParser = new DependencyParser()
    expect(dependencyParser.run pkg).to.eventually.deep.equal
      dep: []
      dev: [{
        name: 'npm-build-tools'
        url: 'https://github.com/Deathspike/npm-build-tools'
        desc: 'Cross-platform command-line tools to help use npm as a build tool.'
      }]

