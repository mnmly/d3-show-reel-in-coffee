define ['d3'], ->

  class LineLayout

    constructor: (options)->

      { @svg,
        @xScale,
        @yScale,
        @symbols,
        @generators,
        @color,
        @height,
        @width,
        @onAnimationEnd }  = options
      @setupScale()
      @symbolNodes = @svg.selectAll('g')
      @kickoffAnimation()

    setupScale: ->

      # Set data range for x` & `y` axis
      @xScale = d3.time.scale().range([0, @width - 60])
      @yScale = d3.scale.linear().range([ @height / 4 - 20, 0])
      
      # Compute the minimum and maximum date across symbols
      @xScale.domain [
        d3.min( @symbols, ( d )-> d.values[0].date )
        d3.max( @symbols, ( d )-> d.values[d.values.length - 1].date )
      ]

    prepareSymbols: ->

      # Get all `symbol` then distributes them horizontally
      @symbolNodes = @svg.selectAll('g')
            .attr( 'transform', ( d, i )=> "translate(0, #{i * @height / 4 + 10})" )
      
      @symbolNodes.each (d, i, j)=>

        # Get `symbol`:[d3 object]
        symbol = d3.select( @symbolNodes[j][i] ) # same as: d3.select(this)

        # Append a line
        symbol.append( 'path' )
          .attr('class', 'line')

        # Append a circle
        symbol.append( 'circle' )
          .attr('r', 5)
          .style('fill', (d) => @color(d.key))
          .style('stroke', '#000')
          .style('stroke-width', '2px')

        # Append a label
        symbol.append( 'text' )
          .attr("x", 12)
          .attr('dy', ".31em")
          .text(d.key)
    

    kickoffAnimation: ->
      # Start the animation at index 1
      k = 1
      n = @symbols[0].values.length
      d3.timer =>
        @draw(k)
        # If the growing index:`k` is about to reach last index,
        # it should cap the value to last index then prepare for next layout
        if ( k += 1 ) >= n - 1
          @draw(n - 1)
          setTimeout @onAnimationEnd, 500
          return yes

    draw: (k)->

      @symbolNodes.each (d, i, j)=>

        symbol = d3.select(@symbolNodes[j][i])

        # Make sure symbol is not going above range
        @yScale.domain [0, d.maxPrice]
        
        # Select a path, then let it draw a line using data from `0` to `k + 1` range,
        # by incrementing this index, the line behaves like it's growing :)
        symbol.select('path')
          .attr('d', (d)=> @generators.line(d.values.slice(0, k + 1)) )
        
        # Select circle and text, then re-position those according to new value
        symbol.selectAll('circle, text')
          .data((d)->[d.values[k], d.values[k]])
          .attr('transform', (d)=> "translate(#{ @xScale(d.date) }, #{@yScale(d.price)})")
