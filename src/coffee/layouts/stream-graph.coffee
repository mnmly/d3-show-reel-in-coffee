define ['d3'], ->

  class StreamGraphLayout

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

      # Create stack layout object to calculate `price0` for later use
      # `y0 - the minimum y-position of the value (baseline).`
      
      stack = d3.layout.stack()
                .values((d)-> d.values)
                .x( (d)-> d.date )
                .y( (d)-> d.price )
                .out( (d, y0, y)-> d.price0 = y0)
                .order('reverse')
                .offset('wiggle')

      # Do calculate here, now accessible to `price0`
      stack(@symbols)

      # Set the line generator's `y` axis to the bottom of stacked layout
      @generators.line.y( (d)=> @yScale(d.price0) )
      
      symbolNodes = @svg.selectAll('.symbol').transition().duration(@duration)

      symbolNodes.select('path.area')
        .attr('d', (d)=> @generators.area(d.values))

      symbolNodes.select('path.line')
        .style('stroke-opacity', 1e-6)
        .attr('d', (d)=> @generators.line(d.values))

      symbolNodes.select('text')
        .attr 'transform', (d)=>
          d = d.values[d.values.length - 1]
          "translate(#{@width - 60}, #{@yScale(d.price / 2 + d.price0)})"
      
      setTimeout @onAnimationEnd, @duration + @delay
