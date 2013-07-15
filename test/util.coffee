magneto = require 'magneto'

exports.shouldThrow = (task) =>
  return (cb) =>
    try
      task()
    catch e
      cb null, true
      return
    throw new Error "did not throw: #{task.toString()}"

exports.shouldNotThrow = (task) =>
  return (cb) =>
    try
      task()
      cb null, true
      return
    catch e
    throw new Error "did throw: #{task.toString()}"

# start magneto, then execute task followed by done
ddb = null
exports.before = (done, task) =>
  set = (ddb) =>
    exports.ddb = ddb
    task?()
    done? null, ddb
  if ddb then set ddb
  else
    port = 4567
    magneto.listen port, (err) =>
      if err? then done? err
      else
        spec =
          apiVersion: '2011-12-05' #'2012-08-10'
          sslEnabled: false
          accessKeyId: 'x'
          secretAccessKey: 'x'
          region: 'x'
          endpoint: "http://localhost:#{port}"
        ddb = require('../lib/ddb').ddb spec
        set ddb

# perform cleanup, then execute task followed by done
exports.after = (done, task) =>
  task?()
  done?()
