logger = require '../logger'
Promise = require 'bluebird'

# Creates a installation informatin
module.exports = class InstallParser
  # @property [String] The name of this component
  @name: "InstallParser"

  # Creates a new InstallParser that parses installation information
  # @param (options) [Object] An optional set of options
  # @option options modules [Array<String>] Module formats supported by the module ['CommonJS']
  constructor: (@options) ->
    @options ?= {}
    @options.modules ?= ['CommonJS']
    @options.unpkg ?= false

  # Create data on installation
  # @param pkg [Object] package.json data
  # @returns [Promise<String>] Install info { modules: names: [string], unpkg: boolean }
  run: (pkg) ->
    logger.info "Creating installation info"
    logger.debug " Adding modules " + @options.modules
    if @options.unpkg
      logger.debug " Adding unpkg"
    Promise.resolve
      modules:
        names: @options.modules.map (module) -> name: module
      unpkg: @options.unpkg
