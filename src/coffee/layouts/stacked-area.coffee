define ['d3'], ->

  class StackedAreaLayout

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

      # Do calculate here, now accessible to `price0`
      stack(@symbols)
      
      # Find maximum value out of list of item that is sum of `d.price` and `d.price0`
      @yScale.domain([
        0
        #200
        d3.max(@symbols[0].values.map( (d)-> d.price + d.price0 ))
      ]).range([@height, 0])

      # Set the line generator's `y` axis to the bottom of stacked layout
      @generators.line.y( (d)=> @yScale(d.price0) )
      
      # Update area's generator, too.
      @generators.area
        .y0( (d)=> @yScale(d.price0) )
        .y1( (d)=> @yScale(d.price0 + d.price) )

      symbolNodes = @svg.selectAll('.symbol').transition().duration(@duration)
                      .attr('transform', 'translate(0, 0)')
                      .each("end", -> d3.select(@).attr('transform', null))

      symbolNodes.select('path.area')
        .attr('d', (d)=> @generators.area(d.values))

      symbolNodes.select('path.line')
        .style('stroke-opacity', (d, i)=> if i < 3 then 1e-6 else 1)
        .attr('d', (d)=> @generators.line(d.values))

      symbolNodes.select('text')
        .attr 'transform', (d)=>
          d = d.values[d.values.length - 1]
          "translate(#{@width - 60}, #{@yScale(d.price / 2 + d.price0)})"
      
      setTimeout @onAnimationEnd, @duration + @delay
