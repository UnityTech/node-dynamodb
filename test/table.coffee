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

describe 'ddb', ->

  before (done) =>
    util.before done, =>
      {@shouldThrow, @shouldNotThrow} = util
      {@schemaTypes, @createTable, @deleteTable, @describeTable, @updateTable, @listTables} = util.ddb
      @table1Name = 'users'
      @table2Name = 'posts'
      @table1Keys = {hash: ['user_id', @schemaTypes().string], range: ['time', @schemaTypes().number]}
      @table2Keys = {hash: ['post_id', @schemaTypes().string], range: ['text', @schemaTypes().string]}
      @provisionedThroughput = {read: 5, write: 5}

  after util.after

  describe '.createTable()', =>

    it.skip 'should create table if table does not exist', (done) =>
      async.series [
        (cb) => @listTables {}, cb
        (cb) => @createTable @table1Name, @table1Keys, @provisionedThroughput, cb
      ], done

  describe '.listTables()', =>

    it.skip 'should not list any tables when no tables exist', (done) =>
      @listTables {}, (err, res) =>
        console.log res
        done err, res

  describe '.deleteTable()', =>

    it 'should'

  describe '.describeTable()', =>

    it 'should'

  describe '.updateTable()', =>

    it 'should'
