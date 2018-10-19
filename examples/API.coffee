# API use

# Default options, explained in documentation
options = {
  debug: false
  silent: false
  encoding: 'utf-8'
  addDescription: ''
  addUsage: ''
  modules: ['CommonJS']
  unpkg: false
  licenseFile: 'LICENSE'
  badges: ['npm-version', 'travis', 'coveralls', 'dependencies', 'devDependencies', 'gitter']
  branch: 'master'
  replaceModuleReferences: true
  filename: 'README.md'
}

ReadmeCreator = require '../'
readmeCreator = new ReadmeCreator(options)
data = readmeCreator.parse()
content = readmeCreator.render data
readme = readmeCreator.write content
readme.catch (err) ->
  throw err
  process.exitCode = 1
