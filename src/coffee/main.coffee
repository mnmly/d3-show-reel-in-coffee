require.config
  baseUrl: 'javascripts'
  paths:
    jquery:      'libs/jquery.min'
    backbone:    'libs/backbone-min'
    underscore:  'libs/underscore-min'
    modernizr:   "libs/modernizr.foundation"
    d3:          'amd-d3'
    
    order:       'libs/rjs-plugins/order'
    text:        'libs/rjs-plugins/text'
    json:        'libs/rjs-plugins/json'

  priority:[
    'modernizr'
    'underscore'
    'jquery'
  ]

require [
  'app'
], (Demo)->
  window.demo = new Demo
  
