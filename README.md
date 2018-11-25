# create-readme
 [![npm version](https://badge.fury.io/js/create-readme.svg)](https://npmjs.org/package/create-readme)  [![downloads](https://img.shields.io/npm/dw/create-readme.svg)](https://npmjs.org/package/create-readme)  [![open issues](https://img.shields.io/github/issues-raw/dbartholomae/create-readme.svg)](https://github.com/dbartholomae/create-readme/issues)  [![license](https://img.shields.io/github/license/dbartholomae/create-readme.svg)](https://github.com/dbartholomae/create-readme/blob/master/LICENSE)  [![debug](https://img.shields.io/badge/debug-blue.svg)](https://github.com/visionmedia/debug#readme)  [![build status](https://img.shields.io/travis/dbartholomae/create-readme/master.svg)](https://travis-ci.org/dbartholomae/create-readme#master)  [![coverage status](https://coveralls.io/repos/dbartholomae/create-readme/badge.svg)](https://coveralls.io/github/dbartholomae/create-readme)  [![dependency status](https://david-dm.org/dbartholomae/create-readme.svg?theme=shields.io)](https://david-dm.org/dbartholomae/create-readme)  [![devDependency status](https://david-dm.org/dbartholomae/create-readme/dev-status.svg)](https://david-dm.org/dbartholomae/create-readme#info=devDependencies)  [![Greenkeeper](https://badges.greenkeeper.io/dbartholomae/create-readme.svg)](https://greenkeeper.io/)  [![semantic release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release#badge)  [![Gitter](https://badges.gitter.im/dbartholomae/create-readme.svg)](https://gitter.im/dbartholomae/create-readme) 

Automatically creates README.md based on package.json and other existing files.

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
- [debug](https://github.com/visionmedia/debug): small debugging utility
- [github-url-to-object](https://github.com/zeke/github-url-to-object): Extract user, repo, and other interesting properties from GitHub URLs
- [mustache](https://github.com/janl/mustache.js): Logic-less {{mustache}} templates with JavaScript
- [require-all](): 


## Dev Dependencies

- [@lluis/codo](https://github.com/coffeedoc/codo): A CoffeeScript documentation generator.
- [@semantic-release/changelog](https://github.com/semantic-release/changelog): semantic-release plugin to create or update a changelog file
- [coffee-script](https://github.com/jashkenas/coffeescript): Unfancy JavaScript
- [coffeelint](https://github.com/clutchski/coffeelint): Lint your CoffeeScript
- [coffeelint-no-mocha-only](https://github.com/rkstedman/coffeelint-no-mocha-only): This CoffeeLint plugin verifies there are no describe.only's or it.only's left in mocha tests
- [coffeelint-variable-scope](https://github.com/fragphace/coffeelint-variable-scope): CoffeeLint rule that warn you when you accidentally overwrite outer scope variable
- [coveralls](https://github.com/nickmerwin/node-coveralls): takes json-cov output into stdin and POSTs to coveralls.io
- [ghooks](https://github.com/gtramontina/ghooks): Simple git hooks
- [mock-fs](https://github.com/tschaub/mock-fs): A configurable mock file system.  You know, for testing.
- [nodemon](https://github.com/remy/nodemon): Simple monitor script for use during development of a node.js app.
- [npm-build-tools](https://github.com/Deathspike/npm-build-tools): Cross-platform command-line tools to help use npm as a build tool.
- [nsp](https://github.com/nodesecurity/nsp): The Node Security (nodesecurity.io) command line interface
- [proxyquire](https://github.com/thlorenz/proxyquire): Proxies nodejs require in order to allow overriding dependencies during testing.
- [semantic-release](https://github.com/semantic-release/semantic-release): Automated semver compliant package publishing
- [test-coffee-module](https://github.com/dbartholomae/test-coffee-module): run tests on .coffee files with sensible defaults
- [validate-commit-msg](https://github.com/conventional-changelog/validate-commit-msg): Script to validate a commit message follows the conventional changelog standard


## License
[MIT](LICENSE)
