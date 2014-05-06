types = {
	STRING: 0
	INTEGER: 1
	DATE: 2
}


typeFromOracle = {
	"VARCHAR2": types.STRING
	"NUMBER": types.INTEGER
}
getType = (str) ->
	if not typeFromOracle[str]? then throw new Error "Invalid type: "+str
	typeFromOracle[str]

module.exports = {types, getType}