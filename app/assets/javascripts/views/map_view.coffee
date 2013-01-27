#= require store
#= require moment
#= require models/map

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


# --

# Class renders an interactive Google Map for Worlds hosted on the Party Cloud. The map is only shown if there is a `last_mapped_at` property of the World as some worlds will be unable to be mapped. In that case it shows a waiting screen.
class App.MapView extends Backbone.View
  model: App.World

  @defaults =
    zoom: 5
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    # scrollwheel: false
    mapTypeId: 'map'
    tileSize: 384
    zoomLevels: 7
    backgroundColor: '#FFF'
    northDirection: 'upper-right'


  template: _.template """
    <div class="map"></div>
    <div class="map-meta">
      Rendered on
      <strong><%= moment(get('last_mapped_at')).format('dddd MMMM Do YYYY') %></strong>
      at
      <strong><%= moment(get('last_mapped_at')).format('h:mma') %></strong>.
    </div>
  """


  initialize: (options) ->
    @options = _.extend(@constructor.defaults, options)
    @options.zoomLevels = @model.get('map_data').zoom_levels

  render: ->
    @$el.html @template(@model)
    @renderMap()

  mapKey = ->
    window.location.pathname

  renderMap: =>
    @map = new google.maps.Map(@$('.map').get(0), @options)
    @loadViewport()

    mapType = new google.maps.ImageMapType(
      getTileUrl: @tileUrl
      tileSize: new google.maps.Size(@options.tileSize, @options.tileSize)
      maxZoom: @options.zoomLevels
      minZoom: 0
    )

    # Can't add the projection in the constructor
    mapType.projection = new MapProjection(@options.tileSize)
    @map.mapTypes.set 'map', mapType

    google.maps.event.addListener @map, 'center_changed', @storeViewport
    google.maps.event.addListener @map, 'zoom_changed', @storeViewport

  storeViewport: =>
    center = @map.getCenter()

    payload =
      zoom: @map.getZoom()
      lat: center.lat()
      lng: center.lng()

    if store.enabled?
      store.set mapKey(), payload

  loadViewport: =>
    if store.enabled? and viewport = store.get(mapKey())
      @map.setZoom viewport.zoom
      @map.setCenter new google.maps.LatLng(viewport.lat, viewport.lng)

    else
      @map.setCenter @worldToLatLng(0, 68, 0)


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
    "#{@model.mapAssetsUrl()}#{tilePath(tile, zoom)}?#{timestamp}"

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


