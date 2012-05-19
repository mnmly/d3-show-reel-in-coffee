// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['d3'], function() {
    var DonutExplodeLayout;
    return DonutExplodeLayout = (function() {

      function DonutExplodeLayout(options) {
        this.tweenArc = __bind(this.tweenArc, this);

        this.transitionExplode = __bind(this.transitionExplode, this);
        this.svg = options.svg, this.xScale = options.xScale, this.yScale = options.yScale, this.symbols = options.symbols, this.generators = options.generators, this.color = options.color, this.height = options.height, this.width = options.width, this.duration = options.duration, this.delay = options.delay, this.onAnimationEnd = options.onAnimationEnd;
        this.prepareSymbols();
      }

      DonutExplodeLayout.prototype.prepareSymbols = function() {
        var _this = this;
        this.r0a = this.height / 2 - this.xScale.rangeBand() / 2;
        this.r1a = this.height / 2;
        this.r0b = 2 * this.height - this.xScale.rangeBand() / 2;
        this.r1b = 2 * this.height;
        this.arc = d3.svg.arc();
        this.svg.selectAll(".symbol path").each(this.transitionExplode);
        return setTimeout((function() {
          _this.svg.selectAll("*").remove();
          _this.svg.selectAll("g").data(_this.symbols).enter().append("g").attr("class", "symbol");
          return _this.onAnimationEnd();
        }), this.duration);
      };

      DonutExplodeLayout.prototype.transitionExplode = function(d, i, j) {
        var pathNode;
        pathNode = this.svg.selectAll('.symbol path')[j][i];
        d.innerRadius = this.r0a;
        d.outerRadius = this.r1a;
        return d3.select(pathNode).transition().duration(this.duration / 2).tween("arc", this.tweenArc({
          innerRadius: this.r0b,
          outerRadius: this.r1b
        }, pathNode));
      };

      DonutExplodeLayout.prototype.tweenArc = function(b, pathNode) {
        var _this = this;
        return function(a) {
          var i, key, path, text;
          path = d3.select(pathNode);
          text = d3.select(pathNode.nextSibling);
          i = d3.interpolate(a, b);
          for (key in b) {
            a[key] = b[key];
          }
          return function(t) {
            a = i(t);
            path.attr("d", _this.arc(a));
            return text.attr("transform", "translate(" + (_this.arc.centroid(a)) + ") translate(" + (_this.width / 2) + ", " + (_this.height / 2) + ")rotate(" + (((a.startAngle + a.endAngle) / 2 + 3 * Math.PI / 2) * 180 / Math.PI) + ")");
          };
        };
      };

      return DonutExplodeLayout;

    })();
  });

}).call(this);