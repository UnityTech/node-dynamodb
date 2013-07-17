magneto = require 'magneto'
{spawn} = require 'child_process'

binPath = './node_modules/.bin'
process.env.PATH = "#{binPath}:#{process.env.PATH}"

task 'test', 'Run test suite', ->
  test = spawn "#{binPath}/mocha", [
    '--compilers', 'coffeem:coffee-script-mapped'
    '--reporter', 'spec'
    '--colors'
    '--bail'
    'test/conversion.coffee'
    'test/table.coffee'
    'test/item.coffee'
    'test/batch.coffee'
  ]
  test.stdout.pipe process.stdout
  test.stderr.pipe process.stderr

task 'test-xunit', 'Run test suite', ->
  test = spawn "#{binPath}/mocha", [
    '--compilers', 'coffeem:coffee-script-mapped'
    '--reporter', 'xunit'
    '--colors'
    '--bail'
    'test/conversion.coffee'
    'test/table.coffee'
    'test/item.coffee'
    'test/batch.coffee'
  ]
  test.stdout.pipe process.stdout
  test.stderr.pipe process.stderr
