Table = require "./Table"
Column = require "./Column"
util = require "util"
types = require "./types"

class ORM
	constructor: (connect) ->
		@connection = {
			"execute": (sql, args, cb) ->
				con sql
				connect.execute sql, args, cb
		}
		@

	getModels: (_) ->
		ret = {}
		tables = @connection.execute "SELECT TABLE_NAME FROM USER_TABLES", [], _
		tables.forEach_ _, -1, (_, table) =>
			columns = @connection.execute "SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH FROM USER_TAB_COLUMNS WHERE TABLE_NAME=:1 ORDER BY COLUMN_ID", [table.TABLE_NAME], _
			columns = columns.map (c) ->
				new Column c.COLUMN_NAME, types.getType(c.DATA_TYPE), c.DATA_LENGTH
			ret[table.TABLE_NAME] = new Table @connection, table.TABLE_NAME, columns, []
		ret

	execute: (sql, args, _) ->
		@connection.execute sql, args, _




module.exports = ORM
