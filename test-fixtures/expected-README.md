# create-readme
 [![npm version](https://badge.fury.io/js/create-readme.svg)](https://npmjs.org/package/create-readme)  [![build status](https://img.shields.io/travis/dbartholomae/create-readme/master.svg)](https://travis-ci.org/dbartholomae/create-readme#master)  [![coverage status](https://coveralls.io/repos/dbartholomae/create-readme/badge.svg)](https://coveralls.io/github/dbartholomae/create-readme)  [![dependency status](https://david-dm.org/dbartholomae/create-readme.svg?theme=shields.io)](https://david-dm.org/dbartholomae/create-readme)  [![devDependency status](https://david-dm.org/dbartholomae/create-readme/dev-status.svg)](https://david-dm.org/dbartholomae/create-readme#info=devDependencies)  [![Gitter](https://badges.gitter.im/dbartholomae/create-readme.svg)](https://gitter.im/dbartholomae/create-readme)  [![Greenkeeper](https://badges.greenkeeper.io/dbartholomae/create-readme.svg)](https://greenkeeper.io/) 

Automatically creates README.md based on package.json and other existing files.

It allows for some customization

## Usage

Configuration options can also be set in package.json's config.readme.

```coffeescript
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

ReadmeCreator = require 'create-readme'
readmeCreator = new ReadmeCreator(options)
data = readmeCreator.parse()
content = readmeCreator.render data
readme = readmeCreator.write content
readme.catch (err) ->
  throw err
  process.exitCode = 1

```

```sh
readme-creator --encoding utf-8 --add-description "" --addUsage "" \
  --modules CommonJS --no-unpkg --license-file LICENSE.txt \
  --badges npm-version,travis,coveralls,dependencies,devDependencies,gitter \
  --branch master \
  README.md

```


## Installation
Download node at [nodejs.org](http://nodejs.org) and install it, if you haven't already.

```sh
npm install create-readme --save
```

This package is provided in these module formats:

- CommonJS



## Documentation

You can find a documentation [here](https://dbartholomae.github.io/create-readme/).

## Dependencies

- [bluebird](https://github.com/petkaantonov/bluebird): Full featured Promises/A+ implementation with exceptionally good performance
- [commander](https://github.com/tj/commander.js): the complete solution for node.js command-line programs
- [github-url-to-object](https://github.com/zeke/github-url-to-object): Extract user, repo, and other interesting properties from GitHub URLs
- [mustache](https://github.com/janl/mustache.js): Logic-less {{mustache}} templates with JavaScript


## Dev Dependencies

- [@lluis/codo](https://github.com/coffeedoc/codo): A CoffeeScript documentation generator.
- [coffee-script](https://github.com/jashkenas/coffeescript): Unfancy JavaScript
- [coffeelint](https://github.com/clutchski/coffeelint): Lint your CoffeeScript
- [coveralls](https://github.com/nickmerwin/node-coveralls): takes json-cov output into stdin and POSTs to coveralls.io
- [ghooks](https://github.com/gtramontina/ghooks): Simple git hooks
- [mock-fs](https://github.com/tschaub/mock-fs): A configurable mock file system.  You know, for testing.
- [nodemon](https://github.com/remy/nodemon): Simple monitor script for use during development of a node.js app.
- [npm-build-tools](https://github.com/Deathspike/npm-build-tools): Cross-platform command-line tools to help use npm as a build tool.
- [proxyquire](https://github.com/thlorenz/proxyquire): Proxies nodejs require in order to allow overriding dependencies during testing.
- [semantic-release](https://github.com/semantic-release/semantic-release): Automated semver compliant package publishing
- [test-coffee-module](https://github.com/dbartholomae/test-coffee-module): run tests on .coffee files with sensible defaults
- [validate-commit-msg](https://github.com/conventional-changelog/validate-commit-msg): Script to validate a commit message follows the conventional changelog standard


## License
[MIT](LICENSE)
