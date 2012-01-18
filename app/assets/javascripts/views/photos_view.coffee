#= require collections/photos_collection
#= require views/photo_view

class MF.PhotosView extends Backbone.View
  collection: MF.PhotosCollection

  initialize: ->
    @subviews = []
    @collection.bind 'add', (model) =>
      console.log 'added', model
      view = new MF.PhotoView(model: model)
      @subviews.push view
      $(@el).append view.el

    @collection.fetch
      success: (c) =>
        c.each (model) =>
          console.log 'added', model
          view = new MF.PhotoView(model: model)
          @subviews.push view
          $(@el).append view.el

  render: ->
    console.log @collection
    console.log 'rendering photos'
    console.log @subviews
    view.render() for view in @subviews

