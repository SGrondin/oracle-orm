Row = require "./Row"
types = require "./types"
helpers = require "./helpers"

class Query
	constructor: (@connection, @table) ->

	select: (where, orderBy, joins, _) ->
		order = if orderBy?
			"ORDER BY "+orderBy.join " AND "
		else
			""
		(@connection.execute "SELECT * FROM "+@table.name+" WHERE "+helpers.getWhere(where)+" "+order, [], _).map (line) =>
			new Row @connection, @table, line

	update: (pairs, where, _) ->
		@connection.execute "UPDATE "+@table.name+" SET "+(helpers.getListPlaceholders pairs, "=").join(", ")+
			" WHERE "+(helpers.getWhere where), (helpers.getValues pairs), _

	updateWithEquals: (pairs, where, _) ->
		@connection.execute "UPDATE "+@table.name+" SET "+(helpers.getListPlaceholders pairs, "=").join(", ")+
			" WHERE "+(helpers.getWhere where, "="), (helpers.getValues pairs), _

	insert: (pairs, _) ->
		columns = Object.keys pairs
		values = helpers.getValues pairs
		placeholders = (helpers.getPlaceholders values.length).join ", "
		@connection.execute "INSERT INTO "+@table.name+"("+columns.join(", ")+") VALUES("+placeholders+")", values, _

	del: (where, _) ->
		@connection.execute "DELETE FROM "+@table.name+" WHERE "+helpers.getWhere(where), [], _

module.exports = Query
