logger = require '../logger'
Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs'
path = require 'path'

# Creates a link to the documentation with the help of
# [rawgit](https://rawgit.com/)
# CAREFUL: The url can only handle limited amounts of traffic and you might get
# blocked from the service, if it is accessed too often. For more information
# see [rawgit](https://rawgit.com/)
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

  # Check whether a documentation exists and the repo uses github.
  # If both conditions are true, create a link to the documentation with
  # [rawgit](https://rawgit.com/)
  # @param pkg [Object] package.json data
  # @returns [Promise<Object>] Documentation information [string]
  run: (pkg) ->
    logger.info "Creating documentation info"
    unless pkg.git?
      logger.debug " Not adding documentation due to missing git repo info"
      return Promise.resolve null
    docDir = pkg.directories?.doc ? './doc/'
    docFile = path.join docDir, @options.docFile

    logger.debug " Looking for doc file at " + docFile
    fs.statAsync docFile
    .then (stats) ->
      if stats.isFile()
        rawgitLink = "https://rawgit.com/" + pkg.git.user + "/" + pkg.git.repo + "/" +
                pkg.git.branch + "/" + docFile.split(path.sep).join "/"
        logger.debug " File found, adding rawgit link " + rawgitLink
        return rawgitLink
      else
        return null
    .catch { code: 'ENOENT' }, -> null
