class Mf.World extends Backbone.Model
  url: -> @get('url')

  isMapped: -> @get('map_assets_url')?
