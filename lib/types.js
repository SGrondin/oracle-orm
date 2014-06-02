(function() {
  var getType, oracle, typeFromOracle, typeToOCCI, types;

  oracle = require("oracle");

  types = {
    STRING: 0,
    NUMBER: 1,
    DATE: 2
  };

  typeFromOracle = {
    "VARCHAR2": types.STRING,
    "CHAR": types.STRING,
    "CLOB": types.STRING,
    "NUMBER": types.NUMBER,
    "DATE": types.DATE
  };

  typeToOCCI = [oracle.OCCISTRING, oracle.OCCINUMBER];

  getType = function(str) {
    if (typeFromOracle[str] == null) {
      throw new Error("Invalid type: " + str);
    }
    return typeFromOracle[str];
  };

  module.exports = {
    types: types,
    getType: getType,
    typeToOCCI: typeToOCCI
  };

}).call(this);
