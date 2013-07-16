###
// Copyright Teleportd Ltd. and other Contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.
###

{assert, expect} = require 'chai'
async = require 'async'
util = require './util'

describe 'ddb item API', ->

  before (done) =>
    util.before done, =>
      {@ddb, @tryCatch, @tryCatchDone, @didThrow, @didNotThrow, @didError, @didNotError} = util
      {@createTable, @deleteTable, @getItem, @putItem, @deleteItem, @updateItem} = util.ddb
      @table1Name = 'users'
      @table2Name = 'posts'
      @table1Keys = {hash: ['user_id', @ddb.schemaTypes().string], range: ['time', @ddb.schemaTypes().number]}
      @table2Keys = {hash: ['post_id', @ddb.schemaTypes().string], range: ['text', @ddb.schemaTypes().string]}
      @provisionedThroughput = {read: 5, write: 5}

  after util.after

  beforeEach (done) =>
    @createTable @table1Name, @table1Keys, @provisionedThroughput, done

  afterEach (done) =>
    @deleteTable @table1Name, done

  it 'should have .getItem() method', =>
    expect(@ddb).to.respondTo 'getItem'

  it 'should have .putItem() method', =>
    expect(@ddb).to.respondTo 'putItem'

  it 'should have .deleteItem() method', =>
    expect(@ddb).to.respondTo 'deleteItem'

  it 'should have .updateItem() method', =>
    expect(@ddb).to.respondTo 'updateItem'

  describe '.getItem()', =>

    it.skip 'should not throw', (done) =>
      async.series [
        #(cb) => @didNotThrow cb, => 
      ], done

  describe '.putItem()', =>

    it.skip 'should not throw', (done) =>
      async.series [
        #(cb) => @didNotThrow cb, =>
      ], done

  describe '.deleteItem()', =>

    it.skip 'should not throw', (done) =>
      async.series [
        #(cb) => @didNotThrow cb, =>
      ], done

  describe '.updateItem()', =>

    it.skip 'should not throw', (done) =>
      async.series [
        #(cb) => @didNotThrow cb, =>
      ], done
