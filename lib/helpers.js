(function() {
  var getListNoPlaceholders, getListPlaceholders, getPKPairs, getPlaceholders, getValues, getWhere, getWhereNoPlaceholders, placeCounter;

  placeCounter = 0;

  getPlaceholders = function(nb) {
    var i, _i, _ref, _results;
    _results = [];
    for (i = _i = placeCounter, _ref = placeCounter + nb - 1; placeCounter <= _ref ? _i <= _ref : _i >= _ref; i = placeCounter <= _ref ? ++_i : --_i) {
      _results.push(":" + (placeCounter++));
    }
    return _results;
  };

  getWhere = function(pairs, separator) {
    var values, where;
    if (separator == null) {
      separator = "";
    }
    where = getListPlaceholders(pairs, separator);
    values = getValues(pairs);
    return [where, values];
  };

  getWhereNoPlaceholders = function(pairs, separator) {
    var where;
    if (separator == null) {
      separator = "";
    }
    where = getListNoPlaceholders(pairs, separator);
    return [where, []];
  };

  getListPlaceholders = function(obj, separator) {
    if (separator == null) {
      separator = "=";
    }
    if (Object.keys(obj).length === 0) {
      return ["1=1"];
    } else {
      return Object.keys(obj).map(function(k) {
        return "\"" + k + "\"" + separator + (getPlaceholders(1));
      });
    }
  };

  getListNoPlaceholders = function(obj, separator) {
    if (separator == null) {
      separator = "=";
    }
    if (Object.keys(obj).length === 0) {
      return ["1=1"];
    } else {
      return Object.keys(obj).map(function(k) {
        return "\"" + k + "\"" + separator + obj[k];
      });
    }
  };

  getValues = function(obj) {
    return Object.keys(obj).map(function(a) {
      return obj[a];
    });
  };

  getPKPairs = function(row) {
    var pairs;
    pairs = {};
    row.table.primary.forEach(function(c) {
      return pairs[c] = row.backdata[c];
    });
    return pairs;
  };

  module.exports = {
    getPlaceholders: getPlaceholders,
    getWhere: getWhere,
    getWhereNoPlaceholders: getWhereNoPlaceholders,
    getValues: getValues,
    getPKPairs: getPKPairs
  };

}).call(this);
