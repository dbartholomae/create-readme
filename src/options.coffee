Promise = require 'bluebird'
winston = require 'winston'

# Sets options based on command line arguments, pkg.config.readme, and defaults
module.exports = class OptionsParser
  # Create a new OptionsSetter
  constructor: -> undefined

  # Set options based on a parameter, pkg.config.readme, and defaults
  # @param pkg [Object] The content of a package.json
  # @param (options) [Object] An object with options to overwrite defaults
  # @returns [Object] The options
  parse: (pkg, options) ->
    winston.info "Parsing options"
    options ?= {}

    if pkg.config?.readme?
      winston.debug "------------------------------------------------"
      winston.debug "Options read from package.json config"
      for own key, val of pkg.config.readme when not options[key]?
        winston.debug key + ": " + val
        options[key] = val
      winston.debug "------------------------------------------------"

    options.git = pkg.git

    options.filename ?= './README.md'

    winston.debug "------------------------------------------------"
    winston.debug "General options:"
    winston.debug JSON.stringify options, null, 2
    winston.debug "------------------------------------------------"

    return options
