(function() {
  var getListPlaceholders, getPKPairs, getPlaceholders, getValues, getWhere, placeCounter;

  placeCounter = 0;

  getPlaceholders = function(nb) {
    var i, _i, _ref, _results;
    _results = [];
    for (i = _i = placeCounter, _ref = placeCounter + nb - 1; placeCounter <= _ref ? _i <= _ref : _i >= _ref; i = placeCounter <= _ref ? ++_i : --_i) {
      _results.push(":" + (placeCounter++));
    }
    return _results;
  };

  getWhere = function(obj, separator) {
    var where;
    if (separator == null) {
      separator = "";
    }
    where = Object.keys(obj).map(function(k) {
      return k + separator + obj[k];
    }).join(" AND ");
    if (where.length === 0) {
      return "1=1";
    } else {
      return where;
    }
  };

  getListPlaceholders = function(obj, separator1) {
    if (separator1 == null) {
      separator1 = "=";
    }
    if (Object.keys(obj).length === 0) {
      throw new Error("getListPlaceholders needs at least one field.");
    }
    return Object.keys(obj).map(function(k) {
      return k + separator1 + (getPlaceholders(1));
    });
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
    getListPlaceholders: getListPlaceholders,
    getValues: getValues,
    getPKPairs: getPKPairs
  };

}).call(this);
