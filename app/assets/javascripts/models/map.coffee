#= require store

class App.Map extends Backbone.Model

  cacheKey: =>
    ['map', @get('id')].join('/')

  tileUrl: (tile, zoom) =>
    ts = new Date(@get('lastMappedAt')).getTime()
    [@assetBaseUrl(), tilePath(tile, zoom), "?#{ts}"].join('')

  assetBaseUrl: ->
    [@get('host'), @get('serverId')].join('/')

# --

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
