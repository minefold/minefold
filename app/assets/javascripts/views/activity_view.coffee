#= require collections/events_collection
#= require views/event_view

#= require views/chat_view
#= require views/connection_view
#= require views/disconnection_view

class MF.ActivityView extends Backbone.View
  id: 'events'

  collection: MF.EventsCollection

  klassBindings =
    chat:       MF.ChatView
    connection: MF.ConnectionView
    disconnection: MF.DisconnectionView

  initialize: (options) ->
    @subViews = @collection.map (model) =>
      type = model.get('type')
      klass = klassBindings[type] || MF.EventView

      new klass(model: model)
  
  addEvent: (event) =>
    type = event.get('type')

    klass = klassBindings[type] || MF.EventView
    
    view = new klass(model: event)

    @subViews.push(view)
    view.render()
    @container.prepend(view.el)
  
  render: ->
    @container = $(@el).empty()

    for view in @subViews
      view.render()
      @container.prepend(view.el)
