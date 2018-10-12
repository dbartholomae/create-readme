debug = require('debug')('create-readme')
levels = ['error', 'warn', 'info', 'verbose', 'debug', 'silly']
for level in levels
  module.exports[level] = debug.extend(level)
