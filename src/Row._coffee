helpers = require "./helpers"

class Row
	constructor: (@connection, @table, @data) ->
		@deleted = false
		@makeBackData()

	makeBackData: ->
		@backdata = {}
		for own k, v of @data
			@backdata[k] = v
		@backdata

	getDirty: ->
		dirty = {}
		for k, v of @backdata
			if v != @data[k]
				dirty[k] = @data[k]
		dirty

	isDirty: ->
		Object.keys(@getDirty()).length > 0

	save: (_) ->
		if @deleted then throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		dirty = @getDirty()
		if Object.keys(dirty).length == 0 then return []
		[update, values1] = helpers.getWhere dirty, "="
		[where, values2] = helpers.getWhere (helpers.getPKPairs @), "="
		r = (@connection.execute "UPDATE \""+@table.name+"\" SET "+update.join(", ")+
			" WHERE "+where.join(" AND "), values1.concat(values2), _)
		if r.updateCount == 0
			@deleted = true
			@data = {}
			throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		else
			@makeBackData()
		@

	sync: (_) ->
		if @deleted then throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		[where, values] = helpers.getWhere (helpers.getPKPairs @), "="
		r = @connection.execute "SELECT * FROM \""+@table.name+"\" WHERE "+where.join(" AND "), values, _
		if r.length == 0
			@deleted = true
			@data = {}
			throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		else
			@data = r[0]
		@makeBackData()
		@

	reset: (_) ->
		@data = @backdata
		@makeBackData()
		@data

	del: (_) ->
		if @deleted then throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		[where, values] = helpers.getWhere (helpers.getPKPairs @), "="
		@deleted = true
		@connection.execute "DELETE FROM \""+@table.name+"\" WHERE "+where.join(" AND "), values, _

module.exports = Row
