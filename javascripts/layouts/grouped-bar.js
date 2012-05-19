// Generated by CoffeeScript 1.3.3
(function() {

  define(['d3'], function() {
    var GroupedBarLayout;
    return GroupedBarLayout = (function() {

      function GroupedBarLayout(options) {
        this.svg = options.svg, this.xScale = options.xScale, this.yScale = options.yScale, this.symbols = options.symbols, this.generators = options.generators, this.color = options.color, this.height = options.height, this.width = options.width, this.duration = options.duration, this.delay = options.delay, this.onAnimationEnd = options.onAnimationEnd;
        this.prepareSymbols();
      }

      GroupedBarLayout.prototype.prepareSymbols = function() {
        var symbolNodes, transSymbolNodes, x1Scale,
          _this = this;
        this.xScale = d3.scale.ordinal().domain(this.symbols[0].values.map(function(d) {
          return d.date;
        })).rangeBands([0, this.width - 60], .1);
        x1Scale = d3.scale.ordinal().domain(this.symbols.map(function(d) {
          return d.key;
        })).rangeBands([0, this.xScale.rangeBand()]);
        symbolNodes = this.svg.selectAll('.symbol');
        transSymbolNodes = symbolNodes.transition().duration(this.duration);
        transSymbolNodes.select('.line').style('stroke-opacity', 1e-6).remove();
        transSymbolNodes.select('.area').style('fill-opacity', 1e-6).remove();
        symbolNodes.each(function(p, i, j) {
          var node;
          node = symbolNodes[j][i];
          return d3.select(node).selectAll('rect').data(function(d) {
            return d.values;
          }).enter().append('rect').attr('x', function(d) {
            return _this.xScale(d.date) + x1Scale(p.key);
          }).attr('y', function(d) {
            return _this.yScale(d.price);
          }).attr('width', x1Scale.rangeBand()).attr('height', function(d) {
            return _this.height - _this.yScale(d.price);
          }).style('fill', _this.color(p.key)).style('fill-opacity', 1e-6).transition().duration(_this.duration).style('fill-opacity', 1);
        });
        return setTimeout(this.onAnimationEnd, this.duration + this.delay);
      };

      return GroupedBarLayout;

    })();
  });

}).call(this);
