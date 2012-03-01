class Mf.World extends Backbone.Model
  url: -> @get('url')

  isMapped: -> @get('map_assets_url')?

  spawn: ->
    _.find @get('map_data').markers, (marker) -> marker.type == 'spawn'
