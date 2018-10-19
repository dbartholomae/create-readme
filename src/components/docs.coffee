logger = require '../logger'
Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs'
path = require 'path'

# Creates a link to the documentation on the corresponding GitHub Pages page.
module.exports = class DocsParser
  # @property [String] The name of this component
  @name: "DocsParser"

  # Creates a new DocsParser
  # @param (options) [Object] An optional set of options
  # @option options encoding [String] Encoding for reading the file ['utf-8']
  # @option options docFile [String] Documentation entry point ['index.html']
  # @option options branch [String] The branch to use for the documentation ['master']
  constructor: (@options) ->
    @options ?= {}
    @options.encoding ?= 'utf-8'
    @options.branch ?= @options.git?.branch ? 'master'
    @options.docFile ?= 'index.html'

  # Check whether a documentation exists, it is in /docs and the repo uses github.
  # If all conditions are true, create a link to the documentation via GitHub Pages.
  # @param pkg [Object] package.json data
  # @returns [Promise<Object>] Documentation information [string]
  run: (pkg) ->
    logger.info "Creating documentation info"
    unless pkg.git?
      logger.debug " Not adding documentation due to missing git repo info"
      return Promise.resolve null
    docDir = pkg.directories?.doc
    unless docDir
      logger.debug " Not adding documentation due to missing directories/doc entry"
      return Promise.resolve null
    unless docDir is 'docs'
      logger.debug " Not adding documentation because it isn't in docs folder " +
        "and therefore incompatible with GitHub Pages"
      return Promise.resolve null

    return Promise.resolve "https://" + pkg.git.user + ".github.io/" + pkg.git.repo + "/"
