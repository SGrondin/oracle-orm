oracle = require "oracle"

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

# Matches the 'types' object. ONLY USED FOR PRIMARY KEYS
typeToOCCI = [oracle.OCCISTRING, oracle.OCCINUMBER]

getType = (str) ->
	if not typeFromOracle[str]? then throw new Error "Invalid type: "+str
	typeFromOracle[str]

module.exports = {types, getType, typeToOCCI}
