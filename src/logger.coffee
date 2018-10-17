debug = require('debug')('create-readme')
levels = ['error', 'warn', 'info', 'verbose', 'debug', 'silly']

for level in levels
  module.exports[level] = debug.extend(level)

Object.defineProperty module.exports, 'level', set: (newLevel) ->
  index = levels.indexOf(newLevel)
  if index is -1
    throw new Error "Level #{newLevel} is not one of the permissible levels #{levels.join(', ')}"
  for i in [0..index]
    logger(levels[i]).enable()
  for i in [index + 1..levels.length - 1]
    logger(levels[i]).disable()
