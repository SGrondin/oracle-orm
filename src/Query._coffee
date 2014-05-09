Row = require "./Row"
types = require "./types"

placeCounter = 0
getPlaceholders = (nb) ->
	(":"+(placeCounter++) for i in [placeCounter..(placeCounter+nb-1)])

getWhereFromObject = (obj) ->
	where = Object.keys(obj).map((k) -> k+obj[k]).join " AND "
	if where.length == 0 then "1=1" else where

getUpdateFromObject = (obj) ->
	if Object.keys(obj).length == 0 then throw new Error "Update needs to update at least one field."
	Object.keys(obj).map((k) -> k+"="+(getPlaceholders 1)).join ", "

getValues = (obj) ->
	Object.keys(obj).map (a) -> obj[a]

class Query
	constructor: (@connection, @table) ->

	select: (where, orderBy, joins, _) ->
		order = if orderBy?
			"ORDER BY "+orderBy.join " AND "
		else
			""
		(@connection.execute "SELECT * FROM "+@table+" WHERE "+getWhereFromObject(where)+" "+order, [], _).map (line) =>
			new Row @connection, @table, line

	update: (columns, where, _) ->
		where = getWhereFromObject where
		con getValues columns
		@connection.execute "UPDATE "+@table+" SET "+(getUpdateFromObject columns)+" WHERE "+where, (getValues columns), _

	insert: (pairs, _) ->
		columns = Object.keys pairs
		values = columns.map (c) -> pairs[c]
		placeholders = (getPlaceholders values.length).join ", "
		@connection.execute "INSERT INTO "+@table+"("+columns.join(", ")+") VALUES("+placeholders+")", values, _

	del: (where, _) ->
		@connection.execute "DELETE FROM "+@table+" WHERE "+getWhereFromObject(where), [], _

module.exports = Query
