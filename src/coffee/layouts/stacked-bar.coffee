define ['d3'], ->

  class StackedBarLayout

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
      
      @xScale.rangeRoundBands( [0, @width - 60 ], .1 )

      stack = d3.layout.stack()
                .values( (d)=> d.values )
                .x( (d)=> d.date )
                .y( (d)=> d.price )
                .out( (d, y0, y)=> d.price0 = y0 )
                .order('reverse')
      
      stack(@symbols)

      symbolNodes = @svg.selectAll('.symbol')
      
      @yScale
        .domain([
          0
          d3.max(@symbols[0].values.map( (d)=> d.price + d.price0 ))
        ]).range([@height, 0])

      transSymbolNodes = symbolNodes.transition().duration(@duration)
      transSymbolNodes.select('text')
        .delay(@symbols[0].values.length * 10)
        .attr 'transform', (d)=>
          d = d.values[d.values.length - 1]
          "translate(#{@width - 60}, #{@yScale(d.price / 2 + d.price0 )})"
      
      that = @
      transSymbolNodes.selectAll('rect')
        .delay((d, i)=> i * 10)
        .attr('y', (d)=> @yScale(d.price0 + d.price))
        .attr('height', (d)=> @height - @yScale(d.price))
        .each "end", ->
          d3.select(this)
            .style('stroke', '#fff')
            .style('stroke-opacity', 1e-6)
          .transition().duration(that.duration / 2)
          .attr('x', (d)=> that.xScale(d.date))
          .attr('width', that.xScale.rangeBand())
          .style('stroke-opacity', 1)
      
      setTimeout @onAnimationEnd, @duration +  @symbols[0].values.length * 10 +  @delay

