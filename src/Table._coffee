Row = require "./Row"
Query = require "./Query"

class Table
	constructor: (@connection, @name, @columns, @primary=[]) ->

	validateColummns: (columnNames=[]) ->
		invalids = columnNames.map((c) => if not @columns[c]? then c else null).filter((a) -> a?)
		if not (invalids.length == 0) then throw new Error "Invalid column(s): "+invalids.join ", "

	add: (pairs, _) ->
		@validateColummns Object.keys pairs
		query = new Query @connection, @
		query.insert pairs, _

	get: (where={}, orderBy=null, _) ->
		@validateColummns Object.keys where
		@validateColummns orderBy?.map (a) -> if a[0] == "-" then a[1..] else a
		query = new Query @connection, @
		query.select where, orderBy, _

	getUnsafe: (where={}, orderBy=null, _) ->
		@validateColummns Object.keys where
		@validateColummns orderBy?.map (a) -> if a[0] == "-" then a[1..] else a
		query = new Query @connection, @, false
		query.select where, orderBy, _

	all: (_) -> @get null, null, _

	update: (columns={}, where={}, _) ->
		@validateColummns Object.keys columns
		@validateColummns Object.keys where
		query = new Query @connection, @
		query.update columns, where, _

	updateUnsafe: (columns={}, where={}, _) ->
		@validateColummns Object.keys columns
		@validateColummns Object.keys where
		query = new Query @connection, @, false
		query.update columns, where, _

	del: (where={}, _) ->
		@validateColummns Object.keys where
		query = new Query @connection, @
		query.del where, _

	delUnsafe: (where={}, _) ->
		@validateColummns Object.keys where
		query = new Query @connection, @, false
		query.del where, _

	count: (_) ->
		r = @connection.execute "SELECT COUNT(*) AS C FROM \""+@name+"\"", [], _
		r[0].C

	empty: (_) ->
		@connection.execute "TRUNCATE TABLE \""+@name+"\"", [], _

module.exports = Table
