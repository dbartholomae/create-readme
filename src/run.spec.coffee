Promise = require 'bluebird'

describe 'A ReadmeCreator', ->
  it.only 'creates a README based on given options and a template', ->
    # TODO: Figure out why stubbing doesn't work
    ReadmeCreator = require './run.coffee'

    return ReadmeCreator.run ['node', 'readme-creator', '-d', '--add-desc', 'test']
    .then ->
      expect(fs.readFileSync 'README.md', { encoding: 'utf-8' }).to.equal 'test'
