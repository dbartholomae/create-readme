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
  # @option options branch [String] The branch to use for the documentation ['master']
  constructor: (@options) ->
    @options ?= {}
    @options.badges ?= [
      'npm-version', 'minzipped', 'travis', 'coveralls', 'dependencies',
      'devDependencies', 'gitter'
    ]
    @options.branch ?= @options.git?.branch ? 'master'

  # Create data for badges
  # @param pkg [Object] package.json data
  # @returns [Promise<Array>] An array of badges {name: string, img: string, url: string}
  run: (pkg) ->
    logger.info "Creating badges"
    unless pkg.git?
      logger.debug " Not adding badges due to missing git repo info"
      return Promise.resolve []
    logger.debug " Adding badges " + @options.badges
    data = Object.assign { branch: @options.branch }, pkg

    return Promise.resolve @options.badges.map (badgeName) ->
      name: mustache.render badgeData[badgeName].name, data
      img: mustache.render badgeData[badgeName].img, data
      url: mustache.render badgeData[badgeName].url, data
