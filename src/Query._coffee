class Query
	constructor: (@connection, @table, @type, @params) ->

	run: (_) ->
		@[@type] _

	select: (_) ->

	update: (_) ->

	insert: (_) ->

	del: (_) ->