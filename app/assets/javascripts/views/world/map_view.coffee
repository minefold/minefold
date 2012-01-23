class MapProjection
  constructor: (@tileSize) ->
    @inverseTileSize = 1.0 / @tileSize
  
  fromLatLngToPoint: (latLng) ->
    x = latLng.lng() * @tileSize
    y = latLng.lat() * @tileSize
    new google.maps.Point(x, y)

  fromPointToLatLng: (point) ->
    lng = point.x * @inverseTileSize
    lat = point.y * @inverseTileSize
    new google.maps.LatLng(lat, lng)  

class Mf.WorldMapView extends Backbone.View
  id: 'map'

  defaults:
    zoom: 5
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    mapTypeId: 'map'
    tileSize: 384
    zoomLevels: 7
    backgroundColor: '#FFF'

  initialize: (options) ->
    @overlay = $(@el).find('.overlay')

    # TODO Refactor
    rawHistory = localStorage.getItem(@model.id)

    if rawHistory?
      history = JSON.parse(rawHistory)
      history.center = new google.maps.LatLng(history.lat, history.lng)

      delete history.lat
      delete history.lng

    @defaults = _.extend @defaults, history
    @options = _.extend @defaults, options.map

    map_data = @model.get('map_data') or []
    spawn = _.find map_data.markers, (marker) -> marker.type == 'spawn'

    @options.center or= if spawn then @worldToLatLng(spawn.x, spawn.z, spawn.y) else @worldToLatLng(0, 0, 68)

    # console.log @model
    
    @map = new google.maps.Map($(@el).find('.map')[0], @options)
    google.maps.event.addListener @map, 'center_changed', @persistViewport
    google.maps.event.addListener @map, 'zoom_changed', @persistViewport
    
    @addMarker spawn, 'Spawn', 'http://google-maps-icons.googlecode.com/files/home.png' if spawn
    
    
  render: ->
    mapType = new google.maps.ImageMapType(
      getTileUrl: @tileUrl
      tileSize: new google.maps.Size(@options.tileSize, @options.tileSize)
      maxZoom: 7
      minZoom: 0
      isPng: true
    )
    
    mapType.projection = new MapProjection(@options.tileSize)
    
    @map.mapTypes.set 'map', mapType

  enter: ->
    @map.setOptions
      disableDoubleClickZoom: false
      draggable: true
      scrollwheel: true
      navigationControl: true
      keyboardShortcuts: true

    @overlay.hide()

  exit: ->
    @overlay.show()

    @map.setOptions
      disableDoubleClickZoom: true
      draggable: false
      scrollwheel: false
      navigationControl: false
      keyboardShortcuts: false

    $('<div></div>').css(
      position: 'absolute'
      top: 0
      right: 0
      bottom: 0
      left: 0
      backgroundColor: 'rgba(0,0,0,0.8)'
    ).after($(@el))

  persistViewport: =>
    center = @map.getCenter()

    data =
      zoom: @map.getZoom()
      lat: center.lat()
      lng: center.lng()

    localStorage.setItem @model.id, JSON.stringify(data)

  tileUrl: (tile, zoom) =>
    url = ''

    if tile.x < 0 or tile.x >= Math.pow(2, zoom) or tile.y < 0 or tile.y >= Math.pow(2, zoom)
      url += '/blank'
    else if zoom == 0
      url += '/base'
    else
      for z in [(zoom - 1)..0]
        x = Math.floor(tile.x / Math.pow(2, z)) % 2
        y = Math.floor(tile.y / Math.pow(2, z)) % 2
        url += "/#{x + 2*y}"

    url += '.png'

    # TODO Add mapped_at cache busting
    @model.get('map_assets_url') + url

  addMarker: (marker, title, icon) =>
    new google.maps.Marker
      position: @worldToLatLng(marker.x, marker.z, marker.y),
      map: @map,
      title: marker.title,
      icon: icon
    
    
  worldToLatLng: (x, y, z) =>
    # the width and height of all the highest-zoom tiles combined,
    # inverted
    
    perPixel = 1.0 / (@options.tileSize * Math.pow(2, @options.zoomLevels))
    
    switch @options.northDirection
      when 'upper-left'
        temp = x
        x = -y-1
        y = temp
      when 'upper-right'
        x = -x-1
        y = -y-1
      when 'lower-right'
        temp = x
        x = y
        y = -temp-1

    # This information about where the center column is may change with
    # a different drawing implementation -- check it again after any
    # drawing overhauls!

    # point (0, 0, 127) is at (0.5, 0.0) of tile (tiles/2 - 1, tiles/2)
    # so the Y coordinate is at 0.5, and the X is at 0.5 -
    # ((tileSize / 2) / (tileSize * 2^zoomLevels))
    # or equivalently, 0.5 - (1 / 2^(zoomLevels + 1))
    lng = 0.5 - (1.0 / Math.pow(2, @options.zoomLevels + 1))
    lat = 0.5

    # the following metrics mimic those in
    # chunk_render in src/iterate.c

    # each block on X axis adds 12px to x and subtracts 6px from y
    lng += 12 * x * perPixel
    lat -= 6 * x * perPixel

    # each block on Y axis adds 12px to x and adds 6px to y
    lng += 12 * y * perPixel
    lat += 6 * y * perPixel

    # each block down along Z adds 12px to y
    lat += 12 * (128 - z) * perPixel

    # add on 12 px to the X coordinate to center our point
    lng += 12 * perPixel

    point = new google.maps.LatLng(lat, lng)
