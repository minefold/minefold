#= require models/world
#= require views/world/map_control_view


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
  model: Mf.World
  className: 'world-map-view'

  defaults:
    zoom: 5
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    mapTypeId: 'map'
    tileSize: 384
    zoomLevels: 7
    backgroundColor: '#F2F2F2'
    northDirection: 'upper-right'
    markers: []

  initialize: (options) ->
    @controls = new Mf.WorldMapControlView(mapView: @)

    @options = _.extend @defaults, options.map
    @options = _.extend @options, @model.get('map_data') or {}

  render: ->
    @map = new google.maps.Map(@el, @options)
    window.map = @map

    mapType = new google.maps.ImageMapType(
      getTileUrl: @tileUrl
      tileSize: new google.maps.Size(@options.tileSize, @options.tileSize)
      maxZoom: 7
      minZoom: 0
    )

    historyPayload = window.localStorage?.getItem(@model.id)
    if historyPayload?
      data = JSON.parse(historyPayload)
      @map.setZoom(data.zoom)

      center = new google.maps.LatLng(data.lat, data.lng)
      @map.setCenter(center)

    else if spawn?
      {x: spawnX, y: spawnY, z: spawnZ} = @model.spawn()
      @map.setCenter @worldToLatLng(spawnX, spawnY, spawnZ)

    else
      @map.setCenter @worldToLatLng(0, 68, 0)

    # Can't add the projection in the constructor
    mapType.projection = new MapProjection(@options.tileSize)
    @map.mapTypes.set 'map', mapType

    # Adds the control view to the top right
    @controls.el.index = 1
    @map.controls[google.maps.ControlPosition.TOP_RIGHT].push @controls.el
    @controls.render()

    spawn = @model.spawn()
    if spawn?
      @addMarker spawn, 'Spawn', '//google-maps-icons.googlecode.com/files/home.png'

    if window.localStorage?
      google.maps.event.addListener map, 'center_changed', @persistViewport
      google.maps.event.addListener map, 'zoom_changed', @persistViewport

  # enter: ->
  #   @map.setOptions
  #     disableDoubleClickZoom: false
  #     draggable: true
  #     scrollwheel: true
  #     navigationControl: true
  #     keyboardShortcuts: true
  #
  # exit: ->
  #   @map.setOptions
  #     disableDoubleClickZoom: true
  #     draggable: false
  #     scrollwheel: false
  #     navigationControl: false
  #     keyboardShortcuts: false

  persistViewport: =>
    center = @map.getCenter()
    data =
      zoom: @map.getZoom()
      lat: center.lat()
      lng: center.lng()

    localStorage.setItem @model.id, JSON.stringify(data)


  tilePath = (tile, zoom) ->
    path = ''

    if tile.x < 0 or tile.x >= Math.pow(2, zoom) or tile.y < 0 or tile.y >= Math.pow(2, zoom)
      path += '/blank'
    else if zoom == 0
      path += '/base'
    else
      for z in [(zoom - 1)..0]
        x = Math.floor(tile.x / Math.pow(2, z)) % 2
        y = Math.floor(tile.y / Math.pow(2, z)) % 2
        path += "/#{x + 2*y}"

    path += '.png'
    path

  tileUrl: (tile, zoom) =>
    timestamp = new Date(@model.get('last_mapped_at')).getTime()

    window.location.protocol + @model.get('map_assets_url') + tilePath(tile, zoom) + '?' + timestamp

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

  enterFullscreen: ->
    @parent = @$el.parent()

    @$el.addClass('fullscreen').appendTo(document.body)

    google.maps.event.trigger @map, 'resize'

    $(document).on 'keydown', @shortcutExitFullscreen

  exitFullscreen: =>
    @$el.removeClass('fullscreen').appendTo(@parent)
    google.maps.event.trigger @map, 'resize'
    @parent = null

  shortcutExitFullscreen: (e) =>
    if e.keyCode is 27
      @exitFullscreen()
      $(document).off 'keydown', @shortcutExitFullscreen

