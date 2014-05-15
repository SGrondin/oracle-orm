util = require "util"
fs = require "fs"
global.con = (v) -> util.puts util.inspect v
global.stack = (err) ->
	util.puts "__"+err.message
	util.puts err.stack

assert = (a, b, number) ->
	if a == b
		console.log ">"+number+" OK "+a+" === "+b
	else
		console.log ">"+number+" FAILED!! "+a+" !== "+b
		throw new Error "Test "+number

oracleConnectData = JSON.parse (fs.readFileSync __dirname+"/../testDB.json").toString("utf8")

ORM = require "oracle-orm"

try
	orm = new ORM oracleConnectData, true, _

	# Arbitrary SQL
	try
		orm.execute "DROP TABLE PERSON", [], _
	catch err
	try
		orm.execute "DROP TABLE \"ORDER\"", [], _
	catch err

	orm.execute "CREATE TABLE PERSON (AAA NUMBER, BBB VARCHAR2(50), F_ORDER_ID NUMBER)", [], _
	orm.execute """ALTER TABLE "#{oracleConnectData.user}"."PERSON" ADD CONSTRAINT PK_PERSON PRIMARY KEY("AAA","F_ORDER_ID")""", [], _

	orm.execute """CREATE TABLE "ORDER" (ORDER_ID NUMBER, "NAME" VARCHAR2(50), NOTE VARCHAR2(50))""", [], _
	orm.execute """ALTER TABLE "#{oracleConnectData.user}"."ORDER" ADD CONSTRAINT PK_ORDER PRIMARY KEY("ORDER_ID")""", [], _

	orm.execute """ALTER TABLE "#{oracleConnectData.user}"."PERSON" ADD CONSTRAINT FK_ORDER FOREIGN KEY("F_ORDER_ID") REFERENCES "ORDER"("ORDER_ID")""", [], _

	models = orm.getModels _
	assert (models.PERSON.count _), 0, "1"


	# Add objects
	models.ORDER.add {ORDER_ID:1, NAME:"avocado"}, _
	models.ORDER.add {ORDER_ID:2, NAME:"banana"}, _
	models.ORDER.add {ORDER_ID:3, NAME:"coconut"}, _
	models.ORDER.add {ORDER_ID:4, NAME:"date"}, _
	models.ORDER.add {ORDER_ID:5, NAME:"eggplant"}, _
	models.ORDER.add {ORDER_ID:6, NAME:"fig"}, _
	models.ORDER.add {ORDER_ID:7, NAME:"grapefruit"}, _

	models.PERSON.add {AAA:10, BBB:"abc", F_ORDER_ID:1}, _
	models.PERSON.add {AAA:20, BBB:"xyz", F_ORDER_ID:2}, _
	models.PERSON.add {AAA:30, BBB:"def", F_ORDER_ID:3}, _
	models.PERSON.add {AAA:40, BBB:"def", F_ORDER_ID:3}, _
	models.PERSON.add {AAA:50, F_ORDER_ID:5}, _
	assert (models.PERSON.count _), 5, "2"


	rows = models.PERSON.all _
	assert rows.length, 5, "3"

	rows = models.PERSON.get {AAA:">35"}, ["AAA"], _
	assert rows.length, 2, "4"

	assert rows[0].connection?.execute?, true, "5"
	assert rows[0].table.name, "PERSON", "6"
	assert rows[0].data.AAA, 40, "7"
	assert rows[0].data.BBB, "def", "8"
	assert rows[1].data.AAA, 50, "9"
	assert rows[1].data.BBB, null, "10"

	# UPDATE
	models.PERSON.update {AAA:-100}, {BBB:"='abc'"}, _
	rows = models.PERSON.get {}, ["F_ORDER_ID", "AAA"], _

	assert rows[0].data.AAA, -100, "11"

	# DELETE
	assert rows[0].deleted, false, "12"
	rows[0].del _
	assert rows[0].deleted, true, "13"
	try
		ok = false
		rows[0].del _
	catch e
		ok = true
	finally assert ok, true, "14"

	rows = models.PERSON.all _
	assert (models.PERSON.count _), 4, "15"
	rows = models.PERSON.get {}, ["AAA"], _

	# SAVE
	assert rows[1].backdata.AAA, rows[1].data.AAA, "16"
	rows[1].data.AAA++
	dirty = rows[1].getDirty()
	assert Object.keys(dirty).length, 1, "17"
	assert rows[1].isDirty(), true, "18"
	assert dirty.AAA, 31, "19"
	rows[1].save _
	dirty = rows[1].getDirty()
	assert Object.keys(dirty).length, 0, "20"
	assert rows[1].isDirty(), false, "21"

	# SYNC
	rows[2].data.BBB = "xyz"
	dirty = rows[2].getDirty()
	assert Object.keys(dirty).length, 1, "22"
	assert rows[2].isDirty(), true, "23"
	rows[2].sync _
	# rows[2].data.BBB == "def" or throw new Error "18"
	dirty = rows[2].getDirty()
	assert Object.keys(dirty).length, 0, "25"
	assert rows[2].isDirty(), false, "26"

	# SAVE clean
	rows[2].save _

	# RESET
	rows[2].data.BBB = "xyz"
	assert rows[2].isDirty(), true, "27"
	rows[2].reset _
	assert rows[2].data.BBB, "def", "28"
	assert rows[2].isDirty(), false, "29"


	##### Run simple tests on ORDER #####
	orders = models.ORDER.get {}, ["-NAME"], _
	assert orders[0].data.NAME, "grapefruit", "30"
	models.ORDER.update {NOTE:"nothing"}, {ORDER_ID:">=3"}, _

	assert (orders.filter (a) -> a.data.NOTE == null).length, 7, "31"
	orders.forEach_ _, -1, (_, a) -> a.sync _
	assert (orders.filter (a) -> a.data.NOTE == null).length, 2, "32"

	assert (models.ORDER.count _), 7, "33"
	models.ORDER.del {ORDER_ID:"=4"}, _
	assert (models.ORDER.count _), 6, "34"

	orders = orders.map_ _, 1, (_, a) -> if not a.deleted? then a.sync _ else a

	assert orders[4].isDirty(), false, "35"
	orders[4].data.NOTE = "APPLE"
	assert orders[4].isDirty(), true, "36"
	orders[4].save _
	assert orders[4].isDirty(), false, "37"

	orm.execute """DELETE FROM "ORDER" WHERE "ORDER_ID"=7""", [], _
	orders[0].data.NOTE = "OOPS"
	try
		ok = false
		orders[0].save _
	catch e
		ok = true
	finally assert ok, true, "38"
	assert orders[0].data.NOTE?, false, "39"

	orders = (models.ORDER.get {}, ["NAME"], _)

	assert orders[4].data.NAME, "fig", "40"
	assert orders[4].isDirty(), false, "41"
	orders[4].data.NAME = "CHANGED"
	assert orders[4].isDirty(), true, "42"
	orders[4].reset _
	assert orders[4].isDirty(), false, "43"

	assert orders[4].deleted, false, "44"
	orders[4].del _
	assert orders[4].deleted, true, "45"


	# EMPTY and DROP PERSON
	models.PERSON.empty _
	assert (models.PERSON.count _), 0, "46"

	orm.execute "DROP TABLE PERSON", [], _
	try
		ok = false
		rows = models.PERSON.all _
	catch e
		ok = true
	finally assert ok, true, "47"

	# EMPTY and DROP ORDER
	models.ORDER.empty _
	assert (models.ORDER.count _), 0, "48"
	orm.execute "DROP TABLE \"ORDER\"", [], _

	console.log "\n\nAll tests passed!\n\n"

catch err
	con err
	stack err


