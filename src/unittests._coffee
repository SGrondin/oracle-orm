util = require "util"
fs = require "fs"
global.con = (v) -> util.puts util.inspect v
global.stack = (err) ->
	util.puts "__"+err.message
	util.puts err.stack

oracleConnectData = JSON.parse (fs.readFileSync __dirname+"/../testDB.json").toString("utf8")
ORM = require "oracle-orm"

try
	orm = new ORM oracleConnectData, _

	# Arbitrary SQL
	orm.execute "CREATE TABLE PERSON (AAA NUMBER, BBB VARCHAR2(50), CCC VARCHAR2(100))", [], _
	orm.execute """ALTER TABLE "#{oracleConnectData.user}"."PERSON" ADD CONSTRAINT PK_PERSON PRIMARY KEY("AAA","CCC")""", [], _
	models = orm.getModels _
	models.PERSON.count(_) == 0 or throw new Error "1"


	# Add objects
	models.PERSON.add {aaa:10, bbb:"abc", ccc:"1"}, _
	models.PERSON.add {aaa:20, bbb:"xyz", ccc:"2"}, _
	models.PERSON.add {aaa:30, bbb:"def", ccc:"3"}, _
	models.PERSON.add {aaa:40, bbb:"def", ccc:"4"}, _
	models.PERSON.add {aaa:50, ccc:"5"}, _
	(models.PERSON.count _) == 5 or throw new Error "2"


	rows = models.PERSON.all _
	rows.length == 5 or throw new Error "3"

	rows = models.PERSON.get {aaa:">35"}, ["AAA ASC"], _
	rows.length == 2 or throw new Error "4"

	rows[0].connection?.execute? or throw new Error "5"
	rows[0].table.name == "PERSON" or throw new Error "6"
	rows[0].data.AAA == 40 and rows[0].data.BBB == "def" or throw new Error "7"
	rows[1].data.AAA == 50 and rows[1].data.BBB == null or throw new Error "8"

	models.PERSON.update {aaa:-100}, {bbb:"='abc'"}, _
	rows = models.PERSON.get {}, ["CCC ASC"], _

	rows[0].data.AAA == -100 or throw new Error "9"

	rows[0].deleted == false or throw new Error "10"
	rows[0].del _
	rows[0].deleted == true or throw new Error "11"
	try
		ok = false
		rows[0].del _
	catch e
		ok = true
	finally
		if not ok then throw new Error "11.1"

	rows = models.PERSON.all _
	(models.PERSON.count _ ) == 4 or throw new Error "12"
	rows = models.PERSON.get {}, ["AAA ASC"], _

	# SAVE
	rows[1].backdata.AAA == rows[1].data.AAA or throw new Error "13"
	rows[1].data.AAA++
	dirty = rows[1].getDirty()
	Object.keys(dirty).length == 1 or throw new Error "14"
	rows[1].isDirty() == true or throw new Error "14.1"
	dirty.AAA == 31 or throw new Error "15"
	rows[1].save _
	dirty = rows[1].getDirty()
	Object.keys(dirty).length == 0 or throw new Error "16"
	rows[1].isDirty() == false or throw new Error "16.1"

	# SYNC
	rows[2].data.BBB = "xyz"
	dirty = rows[2].getDirty()
	Object.keys(dirty).length == 1 or throw new Error "17"
	rows[2].isDirty() == true or throw new Error "17.1"
	rows[2].sync _
	rows[2].data.BBB == "def" or throw new Error "18"
	dirty = rows[2].getDirty()
	Object.keys(dirty).length == 0 or throw new Error "19"
	rows[2].isDirty() == false or throw new Error "19.1"

	# SAVE clean
	rows[2].save _

	# DROP
	models.PERSON.empty _
	models.PERSON.count(_) == 0 or throw new Error "20"
	orm.execute "DROP TABLE PERSON", [], _
	try
		ok = false
		rows = models.PERSON.all _
	catch e
		ok = true
	finally if not ok then throw new Error "21"

catch err
	con err
	stack err


