Line = require "./Line"
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

	update: (fields, where, _) ->
		new Query

	del: (where, _) ->
		new Query

	count: (_) ->
		new Query

	drop: (_) ->
		con @name
		con @connection.execute "DROP TABLE "+@name, [], _

module.exports = Table
