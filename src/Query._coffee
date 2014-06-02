Row = require "./Row"
types = require "./types"
helpers = require "./helpers"

getOrderBy = (orderBy) ->
	if orderBy? and orderBy.length > 0
		orderBy = orderBy.map (a) ->
			if a[0] == "-"
				"\""+a[1..]+"\" DESC"
			else
				"\""+a+"\" ASC"
		"ORDER BY "+orderBy.join ", "
	else
		""

class Query
	constructor: (@connection, @table, safe=true) ->
		@getWhere = if safe
			(obj) ->
				helpers.getWhere obj, "="
		else
			helpers.getWhereNoPlaceholders

	select: (where, orderBy, _) ->
		order = getOrderBy orderBy
		[where, values] = @getWhere where
		(@connection.execute "SELECT * FROM \""+@table.name+"\" WHERE "+where+" "+order, values, _).map (line) =>
			new Row @connection, @table, line

	update: (pairs, where, _) ->
		[update, values1] = helpers.getWhere pairs, "="
		[where, values2] = @getWhere where
		@connection.execute "UPDATE \""+@table.name+"\" SET "+update.join(", ")+
			" WHERE "+where.join(" AND "), values1.concat(values2), _

	insert: (pairs, _) ->
		columns = ("\""+col+"\"" for col in Object.keys pairs)
		values = helpers.getValues pairs
		placeholders = (helpers.getPlaceholders values.length).join ", "
		primaries = @table.primary.map((a) -> a.name).join ", "
		returnPlaceholders = (helpers.getPlaceholders @table.primary.length).join ", "
		params = [].concat values, (new @connection.driver.OutParam(types.typeToOCCI[i.type]) for i in @table.primary)

		@connection.execute "INSERT INTO \""+@table.name+"\"("+columns.join(", ")+") VALUES("+placeholders+") RETURNING "+primaries+" INTO "+
			returnPlaceholders, params, _

	del: (where, _) ->
		[where, values] = @getWhere where
		@connection.execute "DELETE FROM \""+@table.name+"\" WHERE "+where.join(" AND "), values, _

module.exports = Query
