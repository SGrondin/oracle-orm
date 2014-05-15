Row = require "./Row"
Query = require "./Query"

class Table
	constructor: (@connection, @name, @columns, @primary=[]) ->

	add: (pairs, _) ->
		query = new Query @connection, @
		query.insert pairs, _

	get: (where={}, orderBy=null, _) ->
		query = new Query @connection, @
		query.select where, orderBy, [], _

	all: (_) -> @get null, null, _

	update: (columns={}, where={}, _) ->
		query = new Query @connection, @
		query.update columns, where, _

	del: (where={}, _) ->
		query = new Query @connection, @
		query.del where, _

	count: (_) ->
		r = @connection.execute "SELECT COUNT(*) AS C FROM \""+@name+"\"", [], _
		r[0].C

	empty: (_) ->
		@connection.execute "TRUNCATE TABLE \""+@name+"\"", [], _

module.exports = Table
