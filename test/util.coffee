magneto = require 'magneto'

# check if function threw an error
# call done with error when exception is not thrown
# use when task contains async function calls
exports.didThrow = (done, task) =>
  try
    task()
    done new Error "did not throw: #{task.toString()}"
  catch e
    return

# use when task does not contain async function calls
exports.didThrowDone = (task) =>
  return (done) =>
    try
      task()
      done new Error "did not throw: #{task.toString()}"
    catch e
      done()

# check if function did not throw an error
# call done with error when exception is thrown
# use when task contains async function calls
exports.didNotThrow = (done, task) =>
  try
    task()
    return
  catch e
    done new Error "did throw: #{task.toString()}"

# use when task does not contain async function calls
exports.didNotThrowDone = (task) =>
  return (done) =>
    try
      task()
      done()
    catch e
      done new Error "did throw: #{task.toString()}"

# execute task in try/catch block
# call done on error
# use when task contains async function calls
exports.tryCatch = (done, task) =>
  try
    task()
    return
  catch e
    done e

# execute task in try/catch block and follow by done
# call done on error
# use when task does not contain async function calls
exports.tryCatchDone = (done, task) =>
  try
    task()
    done()
  catch e
    done e

exports.didError = (done) =>
  return (err, res) =>
    if err
      done()
    else
      done new Error 'did not return error'

exports.didNotError = (done) =>
  return (err, res) =>
    if err
      done new Error 'did return error'
    else
      done()

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
