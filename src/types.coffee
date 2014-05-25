types = {
	STRING: 0
	NUMBER: 1
	DATE: 2
}


typeFromOracle = {
	"VARCHAR2": types.STRING
	"CHAR": types.STRING
	"CLOB": types.STRING
	"NUMBER": types.NUMBER
	"DATE": types.DATE
}
getType = (str) ->
	if not typeFromOracle[str]? then throw new Error "Invalid type: "+str
	typeFromOracle[str]

module.exports = {types, getType}
