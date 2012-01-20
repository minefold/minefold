#= require collections/events_collection
#= require views/event_view

#= require views/chat_view
#= require views/connection_view
#= require views/disconnection_view

class Mf.ActivityView extends Backbone.View
  id: 'events'

  collection: Mf.EventsCollection

  klassBindings =
    chat:       Mf.ChatView
    connection: Mf.ConnectionView
    disconnection: Mf.DisconnectionView

  initialize: (options) ->
    @subViews = @collection.map (model) =>
      type = model.get('type')
      klass = klassBindings[type] || Mf.EventView

      new klass(model: model)
  
  addEvent: (event) =>
    type = event.get('type')

    klass = klassBindings[type] || Mf.EventView
    
    view = new klass(model: event)

    @subViews.push(view)
    view.render()
    @container.prepend(view.el)
  
  render: ->
    @container = $(@el).empty()

    for view in @subViews
      view.render()
      @container.prepend(view.el)
