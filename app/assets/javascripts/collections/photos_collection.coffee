#= require models/photo

class MF.PhotosCollection extends Backbone.Collection
  url: -> @world.url() + '/photos'
  model: MF.Photo

  initialize: (options) ->
    @world = options.world

