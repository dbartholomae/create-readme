program = require 'commander'
Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs'
mustache = require 'mustache'
logger = require './logger'
requireAll = require 'require-all'
path = require 'path'

PackageJSONReader = require './pkg-json'
OptionsParser = require './options'
TemplateLoader = require './template'

# Creates a README.md based on information from package.json and other files
module.exports = class ReadmeCreator
  # Creates a new ReadmeCreator
  # @param (options) [Object] An optional set of options. See the individual components for details
  # @option options silent [Boolean] Do not write anything to stdout
  # @option options debug [Boolean] Write useful debug messages to stdout
  constructor: (options) ->
    if options.silent
      logger.level = 'silent'

    if options.debug
      logger.level = 'debug'
      if options.silent
        logger.warn "Tried to set both silent and debug flag"

    logger.silly "------------------------------------------------"
    logger.silly "Module invoked with options"
    logger.silly JSON.stringify options, null, 2
    logger.silly "------------------------------------------------"

    @pkg = new PackageJSONReader().read()
    @options = new OptionsParser().parse @pkg, options

  # Parse the readme data
  # @return [Promise] A promise for the data needed for rendering the template
  parse: ->
    return Promise.props requireAll
      dirname: path.join __dirname, 'components'
      filter: /(.*)\.(?:coffee|js)/ # .coffee and .js files
      resolve: (Component) =>
        new Component(@options).run @pkg
        .tap -> logger.debug Component.name + " done"

  # Render the content to the README file template
  # @param content [Object] An object with the data needed for the template
  # @returns [Promise<String>] The rendered template
  render: (content) ->
    logger.debug "Starting render"
    template = new TemplateLoader(@options).loadTemplate()
    Promise.join template, content, (template, content) ->
      logger.silly "---------------------------------"
      logger.silly "Data used for rendering:"
      logger.silly JSON.stringify content, null, 2
      logger.silly "---------------------------------"
      return mustache.render(template, content)

  # Write the given content to the README file
  # @param content [String] The content to write
  # @return [Promise] A promise that resolves when the writing was successful
  write: (content) ->
    logger.debug "Starting write"
    content.then (content) =>
      logger.silly "---------------------------------"
      logger.silly "Wrote to file:"
      logger.silly content
      logger.silly "---------------------------------"
      fs.writeFileAsync @options.filename, content

  # Run the script
  # @overload run(args, cb)
  #   @param args [Array] The arguments to the script.
  #   @param cb [Function] A node-style callback that will be called with any error encountered
  # @overload run(args)
  #   @param args [Array] The arguments to the script.
  #   @return [Promise] A promise that rejects with any errors encountered
  @run: (args = [], cb) ->
    list = (v) -> v.split ','

    optionNames = [
      'filename', 'debug', 'silent', 'encoding', 'addDesc', 'modules', 'npmcdn',
      'licenseFile', 'badges', 'branch', 'docFile', 'replaceReferences'
    ]

    # TODO: Figure out why npmcdn is always on
    program
    .version require('../package.json').version
    .usage '[options] <file>'
    .option '-d, --debug', 'Debug mode'
    .option '-s, --silent', 'Silent mode'
    .option '--encoding <enc>', 'Encoding to use to read files ["utf-8"]'
    .option '-a, --add-desc <text>', 'Text to add to the description [""]'
    .option '-u, --add-usage <text>', 'Text to add to the usage section [""]'
    .option '-m, --modules <modules>', 'List of support module types ' +
                    '["CommonJS"]', list
    .option '-n, --npmcdn', 'Delivery by npmcdn.com'
    .option '--license-file <file>', 'Name of the license file ["LICENSE.txt"]'
    .option '-b, --badges <badges>', 'Badges to use ["npm-version,travis,coveralls,' +
                    'dependencies,devDependencies,gitter"]', list
    .option '--branch <branch>', 'Branch to use for the documentation ["master"]'
    .option '--doc-file <file>', 'Main html file for the documentation ["index.html"]'
    .option '--no-replace-references', 'No replacement of "../" in examples'
    .option '--replace-references', 'Force replacement of "../" in examples'
    .parse args

    if program.args.length > 1
      rejection = Promise.reject 'Only 1 file can be created, files ' +
                      program.args.split(',') + ' were given'
      if cb?
        rejection.catch (err) -> throw err; cb 1
        return
      else
        return rejection

    program.filename = program.args?[0]

    if program.enableReplaceReferences and program.disableReplaceReferences
      logger.warn 'Set both --enable-replace-references as well as ' +
                      '--disable-replace-refrences'
    program.replaceReferences ?= if program.noReplaceReferences? then false else null

    options = {}
    for optionName in optionNames when program[optionName]?
      options[optionName] = program[optionName]

    unless rejection
      readmeCreator = new ReadmeCreator(options)
      data = readmeCreator.parse()
      content = readmeCreator.render data
      readme = readmeCreator.write content

    if cb?
      readme.then -> cb()
      .catch (err) ->
        throw err
        cb 1
      return
    else
      return readme
