#= require collections/photos_collection
#= require views/photo_view

class Mf.PhotosView extends Backbone.View
  collection: Mf.PhotosCollection
  template: _.template ""

  initialize: (options) ->
    @world = options.world

  render: ->
    @collection = new Mf.PhotosCollection(world: @world)

    @collection.fetch
      success: (photos) =>
        @subviews = photos.map (photo) -> new Mf.PhotoView(model: photo)
