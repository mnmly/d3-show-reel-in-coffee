// Generated by CoffeeScript 1.3.3
(function() {

  define(['d3'], function() {
    var StackedAreaLayout;
    return StackedAreaLayout = (function() {

      function StackedAreaLayout(options) {
        this.svg = options.svg, this.xScale = options.xScale, this.yScale = options.yScale, this.symbols = options.symbols, this.generators = options.generators, this.color = options.color, this.height = options.height, this.width = options.width, this.duration = options.duration, this.delay = options.delay, this.onAnimationEnd = options.onAnimationEnd;
        this.prepareSymbols();
      }

      StackedAreaLayout.prototype.prepareSymbols = function() {
        var stack, symbolNodes,
          _this = this;
        stack = d3.layout.stack().values(function(d) {
          return d.values;
        }).x(function(d) {
          return d.date;
        }).y(function(d) {
          return d.price;
        }).out(function(d, y0, y) {
          return d.price0 = y0;
        }).order('reverse');
        stack(this.symbols);
        this.yScale.domain([
          0, d3.max(this.symbols[0].values.map(function(d) {
            return d.price + d.price0;
          }))
        ]).range([this.height, 0]);
        this.generators.line.y(function(d) {
          return _this.yScale(d.price0);
        });
        this.generators.area.y0(function(d) {
          return _this.yScale(d.price0);
        }).y1(function(d) {
          return _this.yScale(d.price0 + d.price);
        });
        symbolNodes = this.svg.selectAll('.symbol').transition().duration(this.duration).attr('transform', 'translate(0, 0)').each("end", function() {
          return d3.select(this).attr('transform', null);
        });
        symbolNodes.select('path.area').attr('d', function(d) {
          return _this.generators.area(d.values);
        });
        symbolNodes.select('path.line').style('stroke-opacity', function(d, i) {
          if (i < 3) {
            return 1e-6;
          } else {
            return 1;
          }
        }).attr('d', function(d) {
          return _this.generators.line(d.values);
        });
        symbolNodes.select('text').attr('transform', function(d) {
          d = d.values[d.values.length - 1];
          return "translate(" + (_this.width - 60) + ", " + (_this.yScale(d.price / 2 + d.price0)) + ")";
        });
        return setTimeout(this.onAnimationEnd, this.duration + this.delay);
      };

      return StackedAreaLayout;

    })();
  });

}).call(this);