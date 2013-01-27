class App.Map extends Backbone.Model
  MapAssetsHost = "//d14m45jej91i3z.cloudfront.net"

  hasMap: ->
    @get('last_mapped_at')?

  mapAssetsUrl: ->
    "#{MapAssetsHost}/#{@get('server_id')}"

# TODO Legacy hack
App.World = App.Map
