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
		where = (helpers.getWhere (helpers.getPKPairs @), "=")
		r = (@connection.execute "UPDATE "+@table.name+" SET "+(helpers.getListPlaceholders dirty, "=").join(", ")+
			" WHERE "+where, (helpers.getValues dirty), _)
		@backdata = @data
		@makeBackData()
		r

	sync: (_) ->
		if @deleted then throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		pairs = helpers.getPKPairs @
		where = (helpers.getListPlaceholders pairs, "=").join " AND "
		r = @connection.execute "SELECT * FROM "+@table.name+" WHERE "+where, (helpers.getValues pairs), _
		@data = r[0]
		@makeBackData()
		r

	del: (_) ->
		if @deleted then throw new Error "Unit "+@table.name+" was deleted and doesn't exist anymore"
		pairs = helpers.getPKPairs @
		where = (helpers.getListPlaceholders pairs, "=").join " AND "
		@deleted = true
		@connection.execute "DELETE FROM "+@table.name+" WHERE "+where, (helpers.getValues pairs), _

module.exports = Row
