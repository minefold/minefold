#= require models/photo

class Mf.PhotosCollection extends Backbone.Collection
  url: -> @world.url() + '/photos'
  model: Mf.Photo

  initialize: (options) ->
    @world = options.world

