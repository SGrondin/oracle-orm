(function() {
  var getType, typeFromOracle, types;

  types = {
    STRING: 0,
    INTEGER: 1,
    DATE: 2
  };

  typeFromOracle = {
    "VARCHAR2": types.STRING,
    "NUMBER": types.INTEGER
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
