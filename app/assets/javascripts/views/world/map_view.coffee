class Mf.WorldMapView extends Backbone.View
  id: 'map'

  defaults:
    zoom: 5
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    mapTypeId: 'map'
    tileSize: 384

  initialize: (options) ->
    @host = options.host

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

    @options.center or= new google.maps.LatLng(0.5, 0.5)

    @map = new google.maps.Map($(@el).find('.map')[0], @options)
    google.maps.event.addListener @map, 'center_changed', @persistViewport
    google.maps.event.addListener @map, 'zoom_changed', @persistViewport

  render: ->
    @map.mapTypes.set 'map', new google.maps.ImageMapType(
      getTileUrl: @tileUrl
      tileSize: new google.maps.Size(@options.tileSize, @options.tileSize)
      maxZoom: 7
      minZoom: 0
      isPng: true
    )

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

    [@host, @model.id].join('/') + url

