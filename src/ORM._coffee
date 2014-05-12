Table = require "./Table"
Column = require "./Column"
util = require "util"
types = require "./types"

class ORM
	constructor: (connect) ->
		@connection = {
			"execute": (sql, args, cb) ->
				console.log sql, args
				connect.execute sql, args, cb
		}

	getModels: (_) ->
		ret = {}
		tables = @connection.execute "SELECT TABLE_NAME FROM USER_TABLES", [], _
		tables.forEach_ _, -1, (_, table) =>
			columns = @connection.execute "SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH FROM USER_TAB_COLUMNS WHERE TABLE_NAME=:1 ORDER BY COLUMN_ID", [table.TABLE_NAME], _
			columns = columns.map (c) ->
				new Column c.COLUMN_NAME, types.getType(c.DATA_TYPE), c.DATA_LENGTH
			primary = @connection.execute ""+
				"SELECT T.CONSTRAINT_NAME AS CONSTRAINT_NAME, C.COLUMN_NAME AS COLUMN_NAME "+
				"FROM ALL_CONSTRAINTS T, ALL_CONS_COLUMNS C WHERE T.OWNER = C.OWNER AND T.CONSTRAINT_NAME = C.CONSTRAINT_NAME AND "+
				"T.TABLE_NAME = :1 AND T.CONSTRAINT_TYPE='P'", [table.TABLE_NAME], _
			primary = primary.map (c) -> c.COLUMN_NAME
			ret[table.TABLE_NAME] = new Table @connection, table.TABLE_NAME, columns, primary
		ret

	execute: (sql, args, _) ->
		@connection.execute sql, args, _


module.exports = ORM
