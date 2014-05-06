class Table
	constructor: (@connection, @name, @columns, @joins) ->

	add: (fields, _) ->
		line = new Line
		line.save _

	get: (where, _) ->
		select = new Select

	getAll: (_) ->
		get {}, _
