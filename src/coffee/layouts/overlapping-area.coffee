define ['d3'], ->

  class OverlappingAreaLayout

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
      
      @generators.line.y( (d)=> @yScale(d.price0 + d.price) )
      
      symbolNodes.select('path.line')
        .attr('d', (d)=> @generators.line(d.values))
      
      @yScale.domain([
        0
        d3.max(@symbols.map( (d)=> d.maxPrice ))
      ]).range([@height, 0])
      
      @generators.area
        .y0(@height)
        .y1((d)=> @yScale(d.price))

      @generators.line
        .y((d)=> @yScale(d.price))

      symbolNodes = symbolNodes.transition().duration(@duration)

      symbolNodes.select('path.line')
        .style('stroke-opacity', 1)
        .attr('d', (d)=> @generators.line(d.values))

      symbolNodes.select('path.area')
        .style('fill-opacity', .5)
        .attr('d', (d)=> @generators.area(d.values))

      symbolNodes.select('text')
        .attr('dy', '.31em')
        .attr 'transform', (d)=>
          d = d.values[d.values.length - 1]
          "translate(#{@width - 60}, #{@yScale(d.price / 2 + d.price0)})"

      @svg.append( 'line' )
        .attr('class', 'line')
        .attr('x1', 0)
        .attr('x2', @width - 60)
        .attr('y1', @height)
        .attr('y2', @height)
        .style('stroke-opacity', 1e-6)
        .transition().duration(@duration)
        .style('stroke-opacity', 1)

      setTimeout @onAnimationEnd, @duration + @delay

