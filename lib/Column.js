(function() {
  var Column;

  Column = (function() {
    function Column(name, type, length) {
      this.name = name;
      this.type = type;
      this.length = length;
      this;
    }

    return Column;

  })();

  module.exports = Column;

}).call(this);
