logger = require '../logger'
Promise = require 'bluebird'

# Parses package.json information
module.exports = class PkgParser
  # @property [String] The name of this component
  @name: "PkgParser"

  # Creates a new PkgParser.
  # @param (options) [Object] An optional set of options, currently not used
  constructor: (@options) -> undefined

  # Parse package.json data. Selects the data that is important for the template only.
  # @param pkg [Object] package.json data
  # @returns [Promise<Object>] The relevant subset of pkg
  run: (pkg) ->
    logger.info "Parsing pkg"
    return Promise.resolve
      name: pkg.name
      version: pkg.version
      private: pkg.private
      preferGlobal: pkg.preferGlobal
