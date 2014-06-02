placeCounter = 0
getPlaceholders = (nb) ->
	(":"+(placeCounter++ % 100) for i in [1..nb])

getWhere = (pairs, separator="") ->
	where = (getListPlaceholders pairs, separator)
	values = getValues pairs
	[where, values]

getWhereNoPlaceholders = (pairs, separator="") ->
	where = (getListNoPlaceholders pairs, separator)
	[where, []]

getListPlaceholders = (obj, separator="=") ->
	if Object.keys(obj).length == 0
		["1=1"]
	else
		Object.keys(obj).map (k) -> "\""+k+"\""+separator+(getPlaceholders 1)

getListNoPlaceholders = (obj, separator="=") ->
	if Object.keys(obj).length == 0
		["1=1"]
	else
		Object.keys(obj).map (k) -> "\""+k+"\""+separator+obj[k]


getValues = (obj) ->
	Object.keys(obj).map (a) -> obj[a]

getPKPairs = (row) ->
	pairs = {}
	row.table.primary.forEach (c) ->
		pairs[c.name] = row.backdata[c.name]
	pairs


module.exports = {getPlaceholders, getWhere, getWhereNoPlaceholders, getValues, getPKPairs}
