define ['d3'], ->

  class AreaLayout

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
      
      @generators.axis.y(@height / 4 - 21)

      # Draws y-axis
      symbolNodes.select('.line').attr('d', (d)=> @generators.axis(d.values))
      
      symbolNodes.each (d, i, j)=>

        node = symbolNodes[j][i]

        # Limit y value to [0, d.maxPrice] range
        @yScale.domain([0, d.maxPrice])
        
        # Fade in opacity of line
        d3.select(node).select('.line').transition().duration(@duration)
          .style('stroke-opacity', 1)
          .each('end', -> d3.select(@).style('stroke-opacity', null))

        # Fade out non-first area elements, btw 0 is false
        d3.select(node).selectAll('.area').filter((d, i)=> i)
          .transition().duration(@duration)
          .style('fill-opacity', 1e-6)
          .attr('d', @generators.area(d.values))
          .remove()

        # Fade in first area elements
        d3.select(node).selectAll('.area').filter( ( d, i )=> not i )
          .transition().duration(@duration)
          .style('fill', @color(d.key))
          .attr('d', @generators.area(d.values))

      # Delete def to remove clip path
      @svg.select('defs').transition().duration(@duration).remove()
      
      # Also remove clip-path attribyte from symbol
      symbolNodes.transition().duration(@duration)
        .each( "end", -> d3.select(@).attr('clip-path', null) )
      
      setTimeout @onAnimationEnd, @duration + @delay
