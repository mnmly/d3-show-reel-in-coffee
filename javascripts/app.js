// Generated by CoffeeScript 1.3.3
(function() {

  define(['d3'], function(d3) {
    /*
      d3.text 'data/auto_mpg_tmp.csv', (datasetText)->
    
        parsedCSV  = d3.csv.parseRows(datasetText)
        sampleHTML = d3.select(".container")
                      .append('table')
                      .style('border-collapse', 'collapse')
                      .style('border', '2px black solid')
    
                      .selectAll('tr').data(parsedCSV)
                      .enter().append('tr')
                      
                      .selectAll('td')
                      .data( (d)-> d ).enter().append('td')
                      .style('border', '1px solid black')
                      .style('padding', '5px')
                      .on('mouseover', -> d3.select(@).style('background-color', 'aliceblue'))
                      .on('mouseout', -> d3.select(@).style('background-color', 'white'))
                      .text( ( d ) -> d)
                      .style('font-size', '12px')
      
      data = [
        [0, 1, 2, 3]
        [4, 5, 6, 7]
        [8, 9, 10, 11]
        [12, 13, 14, 15]
      ]
      container = d3.select('.container')
      table     = container.append('table')
      tr        = table.selectAll('tr').data(data).enter().append('tr')
      td        = tr.selectAll('td').data( (d) -> d ).enter()
                    .append('td')
                    .text(String)
    */

    var Demo, chartHeight, chartWidth, data, dotRadius;
    chartHeight = 300;
    chartWidth = 500;
    dotRadius = 10;
    data = [4, 8, 15, 16, 23, 42];
    return Demo = (function() {

      function Demo() {
        var chart, circles, x, y;
        chart = d3.select('.container').append('svg').attr('class', 'chart').attr('width', chartWidth + 30).attr('height', chartHeight + 15).append('g').attr('transform', 'translate(10, 15)');
        x = d3.scale.linear().domain([0, d3.max(data)]).range([0, chartWidth]);
        y = d3.scale.ordinal().domain(data).rangeBands([0, chartHeight]);
        chart.selectAll('line').data(x.ticks(10)).enter().append('line').attr('x1', x).attr('x2', x).attr('y1', 0).attr('y2', chartHeight).style('stroke', '#ccc');
        circles = chart.selectAll('circle').data(data).enter().append('circle').attr('r', dotRadius).attr('cy', function(d) {
          return d3.round(y(d)) + 10 + .5;
        }).attr('cx', 0).transition().delay(function(d, i) {
          return i * 100;
        }).duration(1000).ease('elastic').attr('cx', function(d) {
          return d3.round(x(d)) + .5;
        });
        /*
              chart.selectAll('rect')
                .data(data).enter().append('rect')
                  .attr('y', y)
                  .attr('width', x)
                  .attr('height', y.rangeBand())
        */

        chart.selectAll('text').data(data).enter().append('text').attr('x', x).attr('y', function(d) {
          return y(d) + y.rangeBand() / 2;
        }).attr('dy', '.35em').attr('text-anchor', 'middle').attr('fill', 'white').text(String);
        chart.selectAll('.rule').data(x.ticks(5)).enter().append('text').attr('class', 'rule').attr('x', x).attr('y', 0).attr('dy', -3).attr('text-anchor', 'middle').text(String);
        chart.append('line').attr('y1', 0).attr('y2', chartHeight).style('stroke', '#000');
      }

      return Demo;

    })();
  });

}).call(this);