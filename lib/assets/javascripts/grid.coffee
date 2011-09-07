#= require jquery

$ ->
  grid = $('#grid')
  grid.find('.toggle').click -> grid.toggleClass('visible')
