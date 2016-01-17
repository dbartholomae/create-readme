Promise = require 'bluebird'
fs = require 'fs'
pkg = require '../package.json'

describe 'A ReadmeCreator', ->
  it 'creates a README based on given options and a template', ->

    ReadmeCreator = require './run.coffee'
    args = ['node', 'readme-creator']
    args.push '--add-desc', pkg.config.readme.addDesc
    args.push '--add-usage', pkg.config.readme.addUsage
    args.push '--modules', 'CommonJS'
    args.push '--license-file', 'LICENSE.txt'
    args.push '--badges', 'npm-version,travis,coveralls,dependencies,devDependencies,gitter'
    args.push '--branch', 'master'
    args.push '--doc-file', 'index.html'
    args.push '--replace-references'
    args.push 'test-fixtures/test-README.md'

    return ReadmeCreator.run args
    .then ->
      expectedReadme = fs.readFileSync 'README.md', { encoding: 'utf-8' }
      expect(fs.readFileSync 'test-fixtures/test-README.md', { encoding: 'utf-8' })
      .to.equal expectedReadme
    .catch (err) ->
      throw err
