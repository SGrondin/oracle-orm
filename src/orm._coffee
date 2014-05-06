Model = require "./Model"

class orm
	constructor: (@connection, _) ->
		createTables _

	createTables: (_) ->
		tables = @connection.execute "select * from tables", [], _

	execute: (sql, args, _) ->
		@connection.execute sql, args, _