logger = require '../logger'
Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs'

# Creates license information
module.exports = class LicenseParser
  # @property [String] The name of this component
  @name: "LicenseParser"

  # Creates a new LicenseParser that checks whether a license file exists
  # and gives its url
  # @param (options) [Object] An optional set of options
  # @option options encoding [String] Encoding for reading the file ['utf-8']
  # @option options licenseFile [String] Location of the license file ['LICENSE']
  constructor: (@options) ->
    @options ?= {}
    @options.encoding ?= 'utf-8'
    @options.licenseFile ?= 'LICENSE'

  # Create license information
  # @param pkg [Object] package.json data
  # @returns [Promise<Object>] License information {name: string, file: string}
  run: (pkg) ->
    logger.info "Creating license info"
    return Promise.resolve null unless pkg.license

    logger.debug " Reading license file from " + @options.licenseFile
    file = fs.readFileAsync @options.licenseFile, { encoding: @options.encoding }
    .then =>
      logger.debug "License file #{@options.licenseFile} found"
      return @options.licenseFile
    .catch { code: 'ENOENT' }, ->
      logger.debug "No license file found"
      return ""

    return Promise.resolve
      name: pkg.license
      file: file
    .props()
