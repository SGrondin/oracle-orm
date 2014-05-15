placeCounter = 0
getPlaceholders = (nb) ->
	(":"+(placeCounter++) for i in [placeCounter..(placeCounter+nb-1)])

getWhere = (obj, separator="") ->
	where = Object.keys(obj).map((k) -> "\""+k+"\""+separator+obj[k]).join " AND "
	if where.length == 0 then "1=1" else where


getListPlaceholders = (obj, separator1="=") ->
	if Object.keys(obj).length == 0 then throw new Error "getListPlaceholders needs at least one field."
	Object.keys(obj).map (k) -> "\""+k+"\""+separator1+(getPlaceholders 1)

getValues = (obj) ->
	Object.keys(obj).map (a) -> obj[a]

getPKPairs = (row) ->
	pairs = {}
	row.table.primary.forEach (c) ->
		pairs[c] = row.backdata[c]
	pairs


module.exports = {getPlaceholders, getWhere, getListPlaceholders, getValues, getPKPairs}
