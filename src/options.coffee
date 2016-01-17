logger = require './logger'

# Sets options based on command line arguments, pkg.config.readme, and defaults
module.exports = class OptionsParser
  # Create a new OptionsSetter
  constructor: -> undefined

  # Set options based on a parameter, pkg.config.readme, and defaults
  # @param pkg [Object] The content of a package.json
  # @param (options) [Object] An object with options to overwrite defaults
  # @returns [Object] The options
  parse: (pkg, options) ->
    logger.info "Parsing options"
    options ?= {}

    if pkg.config?.readme?
      logger.silly "------------------------------------------------"
      logger.silly "Options read from package.json config"
      for own key, val of pkg.config.readme when not options[key]?
        logger.silly key + ": " + val
        options[key] = val
      logger.silly "------------------------------------------------"

    options.git = pkg.git

    options.filename ?= './README.md'

    logger.silly "------------------------------------------------"
    logger.silly "General options:"
    logger.silly JSON.stringify options, null, 2
    logger.silly "------------------------------------------------"

    return options
