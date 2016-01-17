logger = require '../logger'
Promise = require 'bluebird'
path = require 'path'
githubUrl2Obj = require 'github-url-to-object'

# Creates a list of dependencies and devDependencies
module.exports = class DependencyParser
  # @property [String] The name of this component
  @name: "DependencyParser"

  # Creates a new DependencyParser that creates lists of dependencies.
  # @param (options) [Object] An optional set of options
  # @option options addDescription [String] Additional text for the description ['']
  constructor: (@options) ->
    @options ?= {}

  # Find the github repo URL for a dependency and return it together with the name
  # @param dep [String] The name of an installed dependency
  # @returns [String] An object withthe github repo url or null { name: string, url: string }
  getDepData = (dep) ->
    pkgPath = path.join process.cwd(), "node_modules", dep, "package.json"
    logger.debug " Reading " + pkgPath
    pkg = require pkgPath
    if pkg.repository?.url and githubUrl2Obj(pkg.repository.url)
      logger.debug " Adding dependency " + dep
      return {
        name: dep
        # coffeelint: disable=camel_case_vars
        url: githubUrl2Obj(pkg.repository.url).https_url
        # coffeelint: enable=camel_case_vars
        desc: pkg.description ? ""
      }
    else return { name: dep, url: null }

  # Create license information by concatenating options.addDescription to
  # pkg.description, separated by two line breaks.
  # @param pkg [Object] package.json data
  # @returns [Promise<String>] The description
  run: (pkg) ->
    logger.info "Parsing dependencies"

    logger.debug " Loading dependencies: " + Object.keys pkg.dependencies
    logger.debug " Loading devDependencies: " + Object.keys pkg.devDependencies
    Promise.resolve
      dep: Object.keys(pkg.dependencies).map getDepData
      dev: Object.keys(pkg.devDependencies).map getDepData
