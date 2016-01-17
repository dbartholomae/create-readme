winston = require 'winston'
Promise = require 'bluebird'
os = require 'os'

# Creates a description
module.exports = class DescriptionParser
  # @property [String] The name of this component
  @name: "DescriptionParser"

  # Creates a new DescriptionParser that enhances the description.
  # addDescription can optionally be given as an array of strings that will
  # be concatenated by the module. This is to enhance readability
  # of package.json
  # @param (options) [Object] An optional set of options
  # @option options addDescription [String] Additional text for the description ['']
  constructor: (@options) ->
    @options ?= {}
    @options.addDesc ?= ''
    if Array.isArray @options.addDesc
      @options.addDesc = @options.addDesc.join ''

  # Create license information by concatenating options.addDescription to
  # pkg.description, separated by two line breaks.
  # @param pkg [Object] package.json data
  # @returns [Promise<String>] The description
  run: (pkg) ->
    winston.info "Creating description"
    if @options.addDesc.length > 0
      winston.debug " Adding additional description"
      return Promise.resolve pkg.description + os.EOL + os.EOL + @options.addDesc
    else
      winston.debug " Not adding additional description"
      return Promise.resolve pkg.description
