define ['d3'], ->

  class HorizonLayout

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

      # Adding clipPath
      @svg.insert('defs', '.symbol')
        .append('clipPath')
          .attr('id', 'clip')
        .append( 'rect' )
          .attr('width', @width)
          .attr('height', @height / 4 - 20)
      
      # Set the colors
      color = d3.scale.ordinal()
                .range(['#c6bdef', '#9ecae1', '#6baed6'])

      # Apply the clip mask to symbols
      symbolNodes  = @svg.selectAll('.symbol')
                      .attr('clip-path', "url('#clip')")
      
      # Set its baseline
      @generators.area.y0(@height / 4 - 20)
      
      # Transition circles to go beyond the chart canvas, then remove
      symbolNodes.select('circle').transition().duration(@duration)
        .attr('transform', (d)=> "translate(#{@width - 60}, #{(-@height / 4)})")
        .remove()
      
      # Transition text to the baseline of the area
      symbolNodes.select('text').transition().duration(@duration)
        .attr('transform', (d)=> "translate(#{@width - 60}, #{(@height / 4 - 20)})")
        .attr('dy', '0em')
      
      symbolNodes.each (d, i, j)=>

        node = symbolNodes[j][i]

        @yScale.domain([0, d.maxPrice])

        # Create `.area` node inside of which has `path`
        
        d3.select(node).selectAll('.area')
          .data(d3.range(3)).enter().insert( 'path', '.line' )
            .attr('class', 'area')
            # Shift areas vertically
            .attr('transform', (d)=> "translate(0, #{d * ( @height / 4 - 20 )})")
            # Assign the path data
            .attr('d', @generators.area(d.values))
            .style('fill', (d, i)=> color(i))
            .style('fill-opacity', 1e-6)

        # Limit its heigt to a third for lines
        @yScale.domain([0, d.maxPrice / 3])
        
        # Select the line, then 
        d3.select(node).selectAll('.line').transition().duration(@duration)
          .attr('d', @generators.line(d.values))
          .style("stroke-opacity", 1e-6)

        d3.select(node).selectAll('.area').transition().duration(@duration)
          .style('fill-opacity', 1)
          .attr('d', @generators.area(d.values))
          .each( "end", -> d3.select(@).style('fill-opacity', null) )

      setTimeout @onAnimationEnd, @duration + @delay
