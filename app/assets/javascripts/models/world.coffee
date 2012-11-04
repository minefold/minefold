class Application.World extends Backbone.Model
  MapAssetsHost = "//d14m45jej91i3z.cloudfront.net"

  hasMap: ->
    @get('last_mapped_at')?

  mapAssetsUrl: ->
    "#{MapAssetsHost}/#{@get('party_cloud_id')}"
