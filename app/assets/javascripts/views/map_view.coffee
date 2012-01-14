class window.MapView extends Backbone.View
  id: 'map'

  options:
    zoom: 0
    center: new google.maps.LatLng(0.5, 0.5)
    navigationControl: false
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    mapTypeId: 'map'

  constructor: ->

  render: ->
    console.log @options
    new google.maps.Map(@el, @options);
