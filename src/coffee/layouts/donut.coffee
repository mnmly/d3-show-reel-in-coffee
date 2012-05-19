define ['d3'], ->

  class DonutLayout
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
      
      symbolNodes = @svg.selectAll('.symbol')
      symbolNodes.selectAll('rect').remove()
      
      pie = d3.layout.pie()
              .value( (d)=> d.sumPrice )

      @arc = d3.svg.arc()

      that = @

      symbolNodes.append("path")
        .style("fill", (d) => @color d.key)
        .data(=> pie( @symbols ))
        .transition().duration(@duration)
        .tween "arc", (d, i)->
          pathNode = @
          that.arcTween(d, i, pathNode)

      
      symbolNodes.select('text')
        .transition().duration(@duration)
          .attr('dy', '.31em')
      
      @svg.select('line')
        .transition().duration(@duration)
          .attr('y1', 2 * @height)
          .attr('y2', 2 * @height)

      setTimeout @onAnimationEnd, @duration +  @symbols[0].values.length * 10 +  @delay

    arcTween: (d, i, pathNode)->
      path     = d3.select(pathNode)
      text = d3.select(pathNode.parentNode.appendChild(pathNode.previousSibling))
      x0   = @xScale(d.data.key)
      y0   = @height - @yScale(d.data.sumPrice)
      
      (t)=>
        r = @height / 2 / Math.min(1, t + 1e-3)
        a = Math.cos(t * Math.PI / 2)
        xx = (-r + (a) * (x0 + @xScale.rangeBand()) + (1 - a) * (@width + @height) / 2)
        yy = ((a) * @height + (1 - a) * @height / 2)
        f =
          innerRadius: r - @xScale.rangeBand() / (2 - a)
          outerRadius: r
          startAngle: a * (Math.PI / 2 - y0 / r) + (1 - a) * d.startAngle
          endAngle: a * (Math.PI / 2) + (1 - a) * d.endAngle

        path.attr "transform", "translate(" + xx + "," + yy + ")"
        path.attr "d", @arc(f)
        text.attr "transform", "translate(#{ @arc.centroid(f) }) translate(#{ xx } ,#{ yy }) rotate(#{ ((f.startAngle + f.endAngle) / 2 + 3 * Math.PI / 2) * 180 / Math.PI })"
