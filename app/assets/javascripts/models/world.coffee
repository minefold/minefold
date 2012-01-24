class Mf.World extends Backbone.Model
  url: -> @get('url')

  isMapped: -> @get('last_mapped_at')?
