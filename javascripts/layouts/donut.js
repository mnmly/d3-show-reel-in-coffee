// Generated by CoffeeScript 1.3.3
(function() {

  define(['d3'], function() {
    var DonutLayout;
    return DonutLayout = (function() {

      function DonutLayout(options) {
        this.svg = options.svg, this.xScale = options.xScale, this.yScale = options.yScale, this.symbols = options.symbols, this.generators = options.generators, this.color = options.color, this.height = options.height, this.width = options.width, this.duration = options.duration, this.delay = options.delay, this.onAnimationEnd = options.onAnimationEnd;
        this.prepareSymbols();
      }

      DonutLayout.prototype.prepareSymbols = function() {
        var pie, symbolNodes, that,
          _this = this;
        symbolNodes = this.svg.selectAll('.symbol');
        symbolNodes.selectAll('rect').remove();
        pie = d3.layout.pie().value(function(d) {
          return d.sumPrice;
        });
        this.arc = d3.svg.arc();
        that = this;
        symbolNodes.append("path").style("fill", function(d) {
          return _this.color(d.key);
        }).data(function() {
          return pie(_this.symbols);
        }).transition().duration(this.duration).tween("arc", function(d, i) {
          var pathNode;
          pathNode = this;
          return that.arcTween(d, i, pathNode);
        });
        symbolNodes.select('text').transition().duration(this.duration).attr('dy', '.31em');
        this.svg.select('line').transition().duration(this.duration).attr('y1', 2 * this.height).attr('y2', 2 * this.height);
        return setTimeout(this.onAnimationEnd, this.duration + this.symbols[0].values.length * 10 + this.delay);
      };

      DonutLayout.prototype.arcTween = function(d, i, pathNode) {
        var path, text, x0, y0,
          _this = this;
        path = d3.select(pathNode);
        text = d3.select(pathNode.parentNode.appendChild(pathNode.previousSibling));
        x0 = this.xScale(d.data.key);
        y0 = this.height - this.yScale(d.data.sumPrice);
        return function(t) {
          var a, f, r, xx, yy;
          r = _this.height / 2 / Math.min(1, t + 1e-3);
          a = Math.cos(t * Math.PI / 2);
          xx = -r + a * (x0 + _this.xScale.rangeBand()) + (1 - a) * (_this.width + _this.height) / 2;
          yy = a * _this.height + (1 - a) * _this.height / 2;
          f = {
            innerRadius: r - _this.xScale.rangeBand() / (2 - a),
            outerRadius: r,
            startAngle: a * (Math.PI / 2 - y0 / r) + (1 - a) * d.startAngle,
            endAngle: a * (Math.PI / 2) + (1 - a) * d.endAngle
          };
          path.attr("transform", "translate(" + xx + "," + yy + ")");
          path.attr("d", _this.arc(f));
          return text.attr("transform", "translate(" + (_this.arc.centroid(f)) + ") translate(" + xx + " ," + yy + ") rotate(" + (((f.startAngle + f.endAngle) / 2 + 3 * Math.PI / 2) * 180 / Math.PI) + ")");
        };
      };

      return DonutLayout;

    })();
  });

}).call(this);
