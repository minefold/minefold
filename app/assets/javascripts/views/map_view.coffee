class MF.MapView extends Backbone.View
  id: 'map'

  defaults:
    zoom: 5
    navigationControl: true
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    mapTypeId: 'map'
    tileSize: 384

  initialize: (options) ->
    @host = options.host
    @options = _.extend @defaults, options.map
    @options.center or= @determineCenter()

  render: ->
    @map = new google.maps.Map(@el, @options)
    @map.mapTypes.set 'map', new google.maps.ImageMapType(
      getTileUrl: @tileUrl
      tileSize: new google.maps.Size(@options.tileSize, @options.tileSize)
      maxZoom: 7
      minZoom: 0
      isPng: true
    )

    google.maps.event.addListener @map, 'dragend', =>
      center = @map.getCenter()

      data =
        center:
          lat: center.lat()
          lng: center.lng()

      localStorage.setItem 'foo', JSON.stringify(data)

  determineCenter: ->
    local = JSON.parse(localStorage.getItem('foo'))

    if local?
      new google.maps.LatLng(local.center.lat, local.center.lng)
    else
      new google.maps.LatLng(0.5, 0.5)

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

    @host + url

