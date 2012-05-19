define [
  'd3'
  'layouts/line'
  'layouts/horizon'
  'layouts/area'
  'layouts/stacked-area'
  'layouts/stream-graph'
  'layouts/overlapping-area'
  'layouts/grouped-bar'
  'layouts/stacked-bar'
  'layouts/transpose-bar'
  'layouts/donut'
  'layouts/donut-explode'
  ], ( d3, LineLayout, HorizonLayout, AreaLayout, StackedAreaLayout, StreamGraphLayout, OverlappingAreaLayout, GroupedBarLayout, StackedBarLayout, TransposeBarLayout, DonutLayout, DonutExplode)->

  m = [20, 20, 30, 20]
  w = 960 - m[1] - m[3]
  h = 500 - m[0] - m[2]

  class Demo

    constructor: ->
    
      @xScale        = null
      @yScale        = null
      @stocks        = null
      @symbols       = null
      @duration      = 400
      @delay         = 200
      @currentLayout = null

      @color    = d3.scale.category10()
      
      @svg      = @setupCanvas()
      @line     = @setupLine()
      @area     = @setupArea()
      @axis     = @setupAxis()

      @generators =
        line: @line
        area: @area
        axis:  @axis

      @fetchData()


    # setup svg canvas
    setupCanvas: ->

      d3.select('body').append('svg')
        .attr('width', w + m[1] + m[3])
        .attr('height', h + m[0] + m[2])
        .append('g')
          .attr('transform', "translate(#{m[3]}, #{m[0]})")
    
    # Setup baseline
    setupLine: ->
      d3.svg.line()
        .interpolate('basis')
        .x( (d)=> @currentLayout.xScale(d.date))
        .y( (d)=> @currentLayout.yScale(d.price))


    setupArea: ->
      d3.svg.area()
        .interpolate('basis')
        .x( (d) => @currentLayout.xScale(d.date) )
        .y( (d) => @currentLayout.yScale(d.price) )

    setupAxis: ->
      d3.svg.line()
        .interpolate('basis')
        .x( (d)=> @currentLayout.xScale(d.date) )
        .y( h )

    fetchData: ->

      d3.csv 'data/stocks.csv', (data)=>
        
        parse    = d3.time.format('%b %Y').parse
        @symbols = d3.nest().key( (d)->d.symbol )
                    .entries( @stocks = data )
        
        # Parse dates and numbers. We assume values are sorted by date.
        # Also compute the maximum price per symbol, needed for the y-domain.

        @symbols.forEach (s)->
          s.values.forEach (d)->
            # Parse the date to convert into Date object
            d.date  = parse(d.date)
            d.price = +d.price

          # Find max/min price in the dateset
          s.maxPrice = d3.max(s.values, ( d )-> d.price )
          s.sumPrice = d3.sum(s.values, ( d )-> d.price )
        
        # Sort by maximum price decending
        @symbols.sort (a, b)-> b.maxPrice - a.maxPrice
        
        # Represent symbol as `<g class='symbol' />`
        g = @svg.selectAll('g')
              .data(@symbols).enter().append('g')
                .attr('class', 'symbol')
        
        setTimeout @initLineLayout, @duration
      
    setupBaseElements: ->

      symbolNodes = @svg.selectAll('g')
            .attr( 'transform', ( d, i )=> "translate(0, #{i * h / 4 + 10})" )
      
      symbolNodes.each (d, i, j)=>

        # Get `symbol`:[d3 object]
        symbol = d3.select( symbolNodes[j][i] ) # same as: d3.select(this)

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
  
    initLineLayout: =>
      @generators.line = @setupLine()
      # Start lineLayout after `@duration`
      @setupBaseElements()

      if @currentLayout
        @xScale = @currentLayout.xScale
        @yScale = @currentLayout.yScale

      lineLayout = new LineLayout
        svg: @svg
        height: h
        width: w
        xScale: @xScale
        yScale: @yScale
        symbols: @symbols
        generators: @generators
        color: @color
        onAnimationEnd: @initHorizonLayout

      @currentLayout = lineLayout

    initHorizonLayout: =>

      console.log "horizonsLayout starts"

      horizonLayout = new HorizonLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initAreaLayout

      @currentLayout = horizonLayout

    initAreaLayout: =>
      
      console.log "areasLayout starts"

      areaLayout = new AreaLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initStackedAreaLayout

      @currentLayout = areaLayout
    
    initStackedAreaLayout: =>
      console.log "stackedAreaLayout starts"

      stackedAreaLayout = new StackedAreaLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initStreamGraphLayout

      @currentLayout = stackedAreaLayout
      

    initStreamGraphLayout: =>

      console.log "streamGraphLayout starts"

      streamGraphLayout = new StreamGraphLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initOverlappingAreaLayout

      @currentLayout = streamGraphLayout

    initOverlappingAreaLayout: =>

      console.log "overlapping starts"

      overlappingAreaLayout = new OverlappingAreaLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initGroupedBarLayout

      @currentLayout = overlappingAreaLayout

    initGroupedBarLayout: =>

      console.log "groupedBarLayout starts"

      groupedBarLayout = new GroupedBarLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initStackedBarLayout

      @currentLayout = groupedBarLayout

    initStackedBarLayout: =>

      console.log "stackedBarLayout starts"

      stackedBarLayout = new StackedBarLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initTransposeBarLayout

      @currentLayout = stackedBarLayout

    initTransposeBarLayout: =>

      console.log "transposeBarLayout starts"

      transposeBarLayout = new TransposeBarLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initDonutLayout

      @currentLayout = transposeBarLayout

    initDonutLayout: =>

      console.log "donutLayout starts"

      donutLayout = new DonutLayout
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initDonutExplode

      @currentLayout = donutLayout


    initDonutExplode: =>

      console.log "donutLayout starts"

      donutExplode = new DonutExplode
        svg: @svg
        height: h
        width: w
        xScale: @currentLayout.xScale
        yScale: @currentLayout.yScale
        symbols: @symbols
        generators: @generators
        duration: @duration
        delay: @delay
        color: @color
        onAnimationEnd: @initLineLayout

      @currentLayout = donutExplode
