#= require store
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

class App.MapView extends Backbone.View
  model: App.Map

  @defaultMapOptions =
    zoom: 5
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    northDirection: 'upper-right'

  initialize: (options) ->
    @mapOptions = _.extend(@constructor.defaultMapOptions, options)

  render: =>
    @map = new google.maps.Map(@el, @mapOptions)

    viewport = if store.enabled? and payload = store.get(@model.cacheKey())
      center = new google.maps.LatLng(payload.lat, payload.lng)
      { zoom: payload.zoom, center: center }
    else
      spawn = @model.get('spawn')
      defaultZoom = @model.get('zoomLevels') - 1
      { zoom: defaultZoom, center: @worldToLatLng(spawn.x, spawn.y, spawn.z) }

    @map.setCenter(viewport.center)
    @map.setZoom(viewport.zoom)

    tileSize = new google.maps.Size(
      @model.get('tileSize'),
      @model.get('tileSize')
    )

    mapType = new google.maps.ImageMapType(
      getTileUrl: @model.tileUrl
      tileSize: tileSize
      maxZoom: @model.get('zoomLevels')
      minZoom: 0
    )

    mapType.projection = new MapProjection(@model.get('tileSize'))

    @map.mapTypes.set('map', mapType)
    @map.setMapTypeId('map')

    if store.enabled?
      google.maps.event.addListener(@map, 'center_changed', @persist)
      google.maps.event.addListener(@map, 'zoom_changed', @persist)

  persist: =>
    store.set @model.cacheKey(),
      zoom: @map.getZoom()
      lat: @map.getCenter().lat()
      lng: @map.getCenter().lng()

  worldToLatLng: (x, y, z) =>
    # The width and height of all the highest-zoom tiles combined, inverted
    perPixel = 1.0 / (@model.get('tileSize') * Math.pow(2, @model.get('zoomLevels')))

    switch @mapOptions.northDirection
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

    # This information about where the center column is may change with a different drawing implementation - check it again after any drawing overhauls!

    # point (0, 0, 127) is at (0.5, 0.0) of tile (tiles/2 - 1, tiles/2) so the Y coordinate is at 0.5, and the X is at 0.5 - ((tileSize / 2) / (tileSize * 2^zoomLevels)) or equivalently, 0.5 - (1 / 2^(zoomLevels + 1))
    lng = 0.5 - (1.0 / Math.pow(2, @model.get('zoomLevels') + 1))
    lat = 0.5

    # Each block on X axis adds 12px to x and subtracts 6px from y
    lng += 12 * x * perPixel
    lat -= 6 * x * perPixel

    # Each block on Y axis adds 12px to x and adds 6px to y
    lng += 12 * y * perPixel
    lat += 6 * y * perPixel

    # Each block down along Z adds 12px to y
    lat += 12 * (128 - z) * perPixel

    # Add on 12 px to the X coordinate to center our point
    lng += 12 * perPixel

    new google.maps.LatLng(lat, lng)


