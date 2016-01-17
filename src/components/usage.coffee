winston = require 'winston'
Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs'
path = require 'path'
languages = require '../../data/languages.json'

# Parses example files
module.exports = class UsageParser
  # @property [String] The name of this component
  @name: "UsageParser"

  # Creates a new UsageParser
  # addUsage can optionally be given as an array of strings that will
  # be concatenated by the module. This is to enhance readability
  # of package.json
  # @param (options) [Object] An optional set of options
  # @option options encoding [String] Encoding for reading the file ['utf-8']
  # @option options replaceReferences [Boolean] Replace '../' in examples with pkg name [true]
  # @option options addUsage [String] Additional text for the usage section ['']
  constructor: (@options) ->
    @options ?= {}
    @options.encoding ?= 'utf-8'
    @options.addUsage ?= ''
    @options.replaceReferences ?= true

  # Includes the files from the examples directory as usage examples. If
  # `this.options.replaceModuleReferences` is true, Strings of the form
  # `'../'` and `"../"` will be replaced by the package name, so that
  # `require("../")` will show as `require('my-package-name')`.
  # @param pkg [Object] package.json data
  # @returns [Promise<Object>] Usage information [{name: string, file: string}]
  run: (pkg) ->
    winston.info "Creating usage examples"
    exampleDir = pkg.directories?.example ? @options.exampleDir
    exampleDir = path.join(process.cwd(), exampleDir)
    winston.debug " Looking for examples in dir " + exampleDir
    fs.readdirAsync exampleDir
    .catch { code: 'ENOENT' }, -> []
    .filter (file) ->
      Object.keys(languages).indexOf(path.extname(file)) > -1
    .map (file) =>
      winston.debug " Parsing file" + file
      content = fs.readFileAsync path.join(exampleDir, file), { encoding: @options.encoding }
      .then (content) =>
        return content unless @options.replaceReferences
        winston.debug " Replacing occurances of '../' and \"../\" with " + pkg.name
        # Replace occurences of '../' and "../" with 'my-package-name'
        regex = /(?:'\.\.\/')|(?:"\.\.\/")/g
        content.replace regex, "'" + pkg.name + "'"
      Promise.resolve
        lang: languages[path.extname file]
        content: content
      .props()
    .then (examples) =>
      if examples.length is @options.addUsage.length is 0
        winston.debug " No examples and no addUsage"
        return null
      else return {
        examples: examples
        description: @options.addUsage
      }
