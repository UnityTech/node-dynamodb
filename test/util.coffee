{assert} = require 'chai'

exports.shouldThrow = (task) =>
  return (cb) =>
    try
      task()
    catch e
      cb null, true
      return
    assert false, "did not throw: #{task.toString()}"

exports.shouldNotThrow = (task) =>
  return (cb) =>
    try
      task()
      cb null, true
      return
    catch e
    assert false, "did throw: #{task.toString()}"

magnetoRunning = false

# start magneto, execute task and call done
exports.before = (done, task) =>
  if magnetoRunning then done?()
  else
    port = 4567
    magneto = require 'magneto'
    magneto.listen port, (err) =>
      spec = {endpoint: "http://localhost:#{port}"}
      exports.ddb = require('../lib/ddb').ddb(spec)
      magnetoRunning = true
      task?()
      done?()

exports.after = (done, task) =>
  task?()
  done?()
