getPlaceholders = (nb) ->
	(":"+i for i in [1..nb]).join ", "

class Query
	constructor: (@connection, @table) -> @

	select: (where, orderBy, joins, _) ->
		where = Object.keys(where).map((k) -> k+where[k]).join " AND "
		if where.length == 0 then where = "1=1"
		@connection.execute "SELECT * FROM "+@table+" WHERE "+where, [], _

	update: (columns, where, _) ->

	insert: (pairs, _) ->
		columns = Object.keys pairs
		values = columns.map (c) -> pairs[c]
		placeholders = getPlaceholders values.length
		@connection.execute "INSERT INTO "+@table+"("+columns+") VALUES("+placeholders+")", values, _

	del: (where, _) ->

module.exports = Query
