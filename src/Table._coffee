Row = require "./Row"
Query = require "./Query"

class Table
	constructor: (@connection, @name, @columns, @joins) ->

	add: (pairs, _) ->
		query = new Query @connection, @name
		query.insert pairs, _

	get: (where={}, orderBy=null, _) ->
		query = new Query @connection, @name
		query.select where, orderBy, [], _

	all: (_) -> @get null, null, _

	getById: (IDs, _) ->
		new Query

	update: (columns={}, where={}, _) ->
		query = new Query @connection, @name
		query.update columns, where, _

	del: (where={}, _) ->
		query = new Query @connection, @name
		query.del where, _

	count: (_) ->
		new Query

	drop: (_) ->
		@connection.execute "DROP TABLE "+@name, [], _

module.exports = Table
