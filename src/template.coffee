Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs'
path = require 'path'

# Loads the template file
module.exports = class TemplateLoader
  # @property [String] The name of this component
  @name: "TemplateLoader"

  # Creates a new TemplateParser
  # @param (options) [Object] Optional set of options
  # @option options templateFile [String] The template file [__dirname + '/templates/README.md']
  # @option options encoding [String] Encoding for reading the file ['utf-8']
  # @returns [Promise<String>] The template string
  constructor: (@options) ->
    @options ?= {}
    @options.templateFile ?= path.resolve __dirname, '../templates/README.md'
    @options.encoding ?= 'utf-8'

  # Load template
  loadTemplate: ->
    fs.readFileAsync @options.templateFile, { encoding: @options.encoding }
