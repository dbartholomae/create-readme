logger = require '../logger'
Promise = require 'bluebird'
mustache = require 'mustache'
badgeData = require '../../data/badges.json'

# Creates badges based on pkg info
module.exports = class BadgeParser
  # @property [String] The name of this component
  @name: "BadgeParser"

  # Creates a new BadgeParser. By default the following badges will be created:
  # 'npm version', 'build status', 'coverage status', 'dependency status',
  # 'devDependency status', 'Gitter'
  # These can be changed by setting only a subset as options.badges
  # @param (options) [Object] An optional set of options
  # @option options badges [Array<String>] Badges from badges.json to use
  constructor: (@options) ->
    @options ?= {}
    @options.badges ?= [
      'npm-version', 'travis', 'coveralls', 'dependencies',
      'devDependencies', 'gitter'
    ]

  # Create data for badges
  # @param pkg [Object] package.json data
  # @returns [Promise<Array>] An array of badges {name: string, img: string, url: string}
  run: (pkg) ->
    logger.info "Creating badges"
    unless pkg.git?
      logger.debug " Not adding badges due to missing git repo info"
      return Promise.resolve []
    logger.debug " Adding badges " + @options.badges

    return Promise.resolve @options.badges.map (badgeName) ->
      name: mustache.render badgeData[badgeName].name, pkg
      img: mustache.render badgeData[badgeName].img, pkg
      url: mustache.render badgeData[badgeName].url, pkg
