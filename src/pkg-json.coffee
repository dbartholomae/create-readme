Promise = require 'bluebird'
winston = require 'winston'
fs = require 'fs'
path = require 'path'
githubUrl2Obj = require 'github-url-to-object'

# Reads data from package.json
module.exports = class PackageJSONReader
  # REGEXP that gets username and repo name from a github url
  GITHUB_URL_REGEXP = /.*github\.com\/([\w-_\.]+)\/([\w-_\.]+)(?:\.git)/

  # Create a new PackageJSONReader. It checks that package.json contains the fields
  # [['name', 'version', 'description']]
  # @param (options) [Object] Optional options.
  # @option options fieldsNeeded [Array<String>] Fields required from packages.json
  constructor: (@options) ->
    @options ?= {}
    @options.fieldsNeeded ?= ['name', 'version', 'description']

  # Reads package.json
  # @returns [Object] The parsed data from package.json
  read: ->
    pkg = require path.join(process.cwd(), 'package.json')
    # Check if all required fields are filled in
    for fieldName in @options.fieldsNeeded
      unless pkg[fieldName]?
        throw new Error 'package.json ' + fieldName + ' field has to be defined'

    # Parse git repo url
    if pkg.repository?.type is 'git'
      try
        pkg.git = githubUrl2Obj(pkg.repository.url)
        unless pkg.git.user?.length > 0 and pkg.git.repo?.length > 0
          pkg.git = undefined
          winston.warn 'No git repository defined'
      catch
        throw new Error 'package.json repository.url cannot be parsed'

    return pkg
