(function() {
  var getType, typeFromOracle, types;

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

  getType = function(str) {
    if (typeFromOracle[str] == null) {
      throw new Error("Invalid type: " + str);
    }
    return typeFromOracle[str];
  };

  module.exports = {
    types: types,
    getType: getType
  };

}).call(this);
