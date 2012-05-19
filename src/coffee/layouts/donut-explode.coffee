define ['d3'], ->

  class DonutExplodeLayout

    constructor: (options)->

      { @svg,
        @xScale,
        @yScale,
        @symbols,
        @generators,
        @color,
        @height,
        @width,
        @duration,
        @delay,
        @onAnimationEnd }  = options
      
      @prepareSymbols()


    prepareSymbols: ->

      @r0a = @height / 2 - @xScale.rangeBand() / 2
      @r1a = @height / 2
      @r0b = 2 * @height - @xScale.rangeBand() / 2
      @r1b = 2 * @height
      @arc = d3.svg.arc()

      @svg.selectAll(".symbol path").each @transitionExplode

      setTimeout (=>
        @svg.selectAll("*").remove()
        @svg.selectAll("g").data(@symbols).enter().append("g").attr "class", "symbol"
        @onAnimationEnd()
      ), @duration
        
    transitionExplode: (d, i, j) =>
      pathNode = @svg.selectAll('.symbol path')[j][i]
      d.innerRadius = @r0a
      d.outerRadius = @r1a
      d3.select(pathNode).transition().duration(@duration / 2).tween "arc", @tweenArc({
        innerRadius: @r0b
        outerRadius: @r1b
      }, pathNode)

    tweenArc: (b, pathNode) =>
      (a) =>
        path = d3.select(pathNode)
        text = d3.select(pathNode.nextSibling)
        i = d3.interpolate(a, b)
        for key of b
          a[key] = b[key]
        (t) =>
          a = i(t)
          path.attr "d", @arc(a)
          text.attr "transform", "translate(#{ @arc.centroid(a) }) translate(#{ @width / 2 }, #{ @height / 2 })rotate(#{ ((a.startAngle + a.endAngle) / 2 + 3 * Math.PI / 2) * 180 / Math.PI })"

