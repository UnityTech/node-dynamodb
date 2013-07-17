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

describe 'ddb table API', ->

  before (done) =>
    util.before done, =>
      {@ddb, @tryCatch, @tryCatchDone, @didThrow, @didNotThrow, @expectError, @expectNoError} = util
      {@listTables, @createTable, @deleteTable, @describeTable, @updateTable} = util.ddb
      @table1Name = 'users'
      @table2Name = 'posts'
      @table1Keys = {hash: ['user_id', @ddb.schemaTypes().string], range: ['time', @ddb.schemaTypes().number]}
      @table2Keys = {hash: ['post_id', @ddb.schemaTypes().string], range: ['text', @ddb.schemaTypes().string]}
      @provisionedThroughput = {read: 5, write: 5}

  after util.after

  it 'should have .listTables() method', =>
    expect(@ddb).to.respondTo 'listTables'

  it 'should have .createTable() method', =>
    expect(@ddb).to.respondTo 'createTable'

  it 'should have .deleteTable() method', =>
    expect(@ddb).to.respondTo 'deleteTable'

  it 'should have .describeTable() method', =>
    expect(@ddb).to.respondTo 'describeTable'

  it 'should have .updateTable() method', =>
    expect(@ddb).to.respondTo 'updateTable'

  describe '.listTables()', =>

    it 'should not throw', (done) =>
      async.series [
        (cb) => @didNotThrow cb, =>
          @listTables {}, cb
      ], done

    it 'should not list any tables when no tables exist', (done) =>
      async.waterfall [
        (cb) => @tryCatch cb, =>
          @listTables {}, cb

        (tables, cb) => @tryCatchDone cb, =>
          assert.isArray tables, 'should return array of table names'
          assert.equal tables.length, 0, 'should return empty array of table names'
      ], done

  describe '.createTable()', =>

    it 'should not throw', (done) =>
      async.series [
        (cb) => @didNotThrow cb, =>
          @createTable @table2Name, @table2Keys, @provisionedThroughput, cb

        (cb) => @tryCatch cb, =>
          @deleteTable @table2Name, cb
      ], done

    it 'should create table if table does not exist', (done) =>
      async.waterfall [
        (cb) => @tryCatch cb, =>
          @createTable @table1Name, @table1Keys, @provisionedThroughput, cb

        (table, cb) => @tryCatchDone cb, =>
          expect(table).to.contain.keys 'TableName', 'KeySchema', 'TableStatus'
          expect(table.TableName).to.equal @table1Name
          expect(table.TableStatus).to.equal 'ACTIVE'

        (cb) => @tryCatch cb, =>
          @listTables {}, cb

        (tables, cb) => @tryCatchDone cb, =>
          assert.isArray tables, 'should return array of table names'
          assert.equal tables.length, 1, 'should return single table name'
          assert.equal tables[0], @table1Name
      ], done

    it 'should fail to create table that already exists', (done) =>
      async.series [
        (cb) => @createTable @table1Name, @table1Keys, @provisionedThroughput, @expectError(cb)
      ], done

  describe '.describeTable()', =>

    it 'should not throw', (done) =>
      async.series [
        (cb) => @didNotThrow cb, =>
          @describeTable @table1Name, cb
      ], done

    it 'should return information about existing table', (done) =>
      async.waterfall [
        (cb) => @tryCatch cb, =>
          @describeTable @table1Name, cb

        (table, cb) => @tryCatchDone cb, =>
          expect(table).to.contain.keys 'TableName', 'ProvisionedThroughput', 'TableStatus'
          expect(table.TableName).to.equal @table1Name
          expect(table.TableStatus).to.equal 'ACTIVE'
          expect(table.ProvisionedThroughput.ReadCapacityUnits).to.equal @provisionedThroughput.read
          expect(table.ProvisionedThroughput.WriteCapacityUnits).to.equal @provisionedThroughput.write
      ], done

    it 'should fail to describe table that does not exist', (done) =>
      async.series [
        (cb) => @describeTable @table2Name, @expectError(cb)
      ], done

  describe '.updateTable()', =>

    it 'should not throw', (done) =>
      async.series [
        (cb) => @didNotThrow cb, =>
          @updateTable @table1Name, {read: 1, write: 1}, cb

        (cb) => @tryCatch cb, =>
          @updateTable @table1Name, @provisionedThroughput, cb
      ], done

    it 'should update provisioned throughput of existing table', (done) =>
      async.waterfall [
        (cb) => @tryCatch cb, =>
          @describeTable @table1Name, cb

        (table, cb) => @tryCatchDone cb, =>
          expect(table).to.contain.keys 'ProvisionedThroughput'
          expect(table.ProvisionedThroughput.ReadCapacityUnits).to.equal @provisionedThroughput.read
          expect(table.ProvisionedThroughput.WriteCapacityUnits).to.equal @provisionedThroughput.write

        (cb) => @tryCatch cb, =>
          @updateTable @table1Name, {read: 10, write: 10}, cb

        (table, cb) => @tryCatch cb, =>
          # magneto currently has an issue where updateTable does not return table description
          # https://github.com/exfm/node-magneto/issues/8
          @describeTable @table1Name, cb

        (table, cb) => @tryCatchDone cb, =>
          expect(table).to.contain.keys 'ProvisionedThroughput'
          expect(table.TableName).to.equal @table1Name
          expect(table.ProvisionedThroughput.ReadCapacityUnits).to.equal 10
          expect(table.ProvisionedThroughput.WriteCapacityUnits).to.equal 10
      ], done

    it 'should fail to update table that does not exist', (done) =>
      async.series [
        (cb) => @updateTable @table2Name, @provisionedThroughput, @expectError(cb)
      ], done

  describe '.deleteTable()', =>

    it 'should not throw', (done) =>
      async.series [
        (cb) => @tryCatch cb, =>
          @createTable @table2Name, @table2Keys, @provisionedThroughput, cb

        (cb) => @didNotThrow cb, =>
          @deleteTable @table2Name, cb
      ], done

    it 'should delete table if table already exists', (done) =>
      async.waterfall [
        (cb) => @tryCatch cb, =>
          @deleteTable @table1Name, cb

        (table, cb) => @tryCatchDone cb, =>
          expect(table).to.contain.keys 'TableName', 'KeySchema', 'TableStatus'
          expect(table.TableName).to.equal @table1Name
          expect(table.TableStatus).to.equal 'DELETING'

        (cb) => @tryCatch cb, =>
          @listTables {}, cb

        (tables, cb) => @tryCatchDone cb, =>
          assert.isArray tables, 'should return array of table names'
          assert.equal tables.length, 0, 'should return empty array of table names'
      ], done

    it 'should fail to delete table that does not exist', (done) =>
      async.series [
        (cb) => @deleteTable @table1Name, @expectError(cb)
      ], done
