define ['d3'], ->

  class TransposeBarLayout

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
      
      @xScale
        .domain( @symbols.map( (d)=> d.key ) )
        .rangeRoundBands([0, @width], .2)

      @yScale
        .domain(
          [ 0
            d3.max @symbols.map (d)=> d3.sum d.values.map (d)=> d.price
          ])

      stack = d3.layout.stack()
                .x( (d, i)=> i )
                .y( (d)=> d.price )
                .out( (d, y0, y)=> d.price0 = y0 )
      
      stack( d3.zip.apply null, @symbols.map( (d)=> d.values ) ) # Transpose

      symbolNodes = @svg.selectAll('.symbol')
      transSymbolNodes = symbolNodes.transition().duration(@duration / 2)

      transSymbolNodes.selectAll('rect')
        .delay((d, i)=> i * 10)
        .attr('y', (d)=> @yScale(d.price0 + d.price) - 1)
        .attr('height', (d)=> @height - @yScale(d.price) + 1)
        .attr('x', (d)=> @xScale(d.symbol))
        .attr('width', @xScale.rangeBand())
        .style('stroke-opacity', 1e-6)
      
      transSymbolNodes.select('text')
        .attr('x', 0)
        .attr('transform', (d)=>
          "translate(#{@xScale(d.key) + @xScale.rangeBand() / 2}, #{@height})"
        ).attr('dy', '1.31em')
        .each "end", (d, i, j)->
          # Get `symbol`:[d3 object]
          d3.select(@) # same as: d3.select(this)
            .attr('x', null)
            .attr('text-anchor', 'middle')
      
      @svg.select('line')
        .transition().duration(@duration)
          .attr('x2', @width)
          
      setTimeout @onAnimationEnd, @duration +  @symbols[0].values.length * 10 +  @delay

