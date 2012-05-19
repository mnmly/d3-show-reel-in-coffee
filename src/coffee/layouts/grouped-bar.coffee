define ['d3'], ->

  class GroupedBarLayout

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
      
      @xScale = d3.scale.ordinal()
                  .domain( @symbols[0].values.map (d)-> d.date )
                  .rangeBands([0, @width - 60], .1)

      x1Scale = d3.scale.ordinal()
                  .domain( @symbols.map (d)-> d.key )
                  .rangeBands([0, @xScale.rangeBand()])
      
      symbolNodes = @svg.selectAll('.symbol')
      
      transSymbolNodes = symbolNodes.transition().duration(@duration)
      
      # Fade out line then remove it
      transSymbolNodes.select('.line')
          .style('stroke-opacity', 1e-6)
          .remove()

      # Fade out areas then remove it
      transSymbolNodes.select('.area')
          .style('fill-opacity', 1e-6)
          .remove()
      
      symbolNodes.each (p, i, j)=>
        node = symbolNodes[j][i]
        d3.select(node).selectAll('rect')
          .data( (d)=> d.values ).enter().append('rect')
            .attr('x', (d)=> @xScale(d.date) + x1Scale(p.key))
            .attr('y', (d)=> @yScale(d.price))
            .attr('width', x1Scale.rangeBand())
            .attr('height', (d)=> @height - @yScale(d.price))
            .style('fill', @color(p.key))
            .style('fill-opacity', 1e-6)
          .transition()
            .duration(@duration)
            .style('fill-opacity', 1)

      setTimeout @onAnimationEnd, @duration + @delay
