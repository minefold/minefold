#= require collections/events_collection
#= require views/event_view
#= require views/chat_view

class MF.ActivityView extends Backbone.View
  id: 'events'

  collection: MF.EventsCollection

  initialize: (options) ->
    @subViews = @collection.map (model) =>
      type = model.get('type')

      klass = switch type
              when 'chat' then MF.ChatView
              else MF.EventView

      new klass(model: model)

    @collection.bind 'add', (model) =>
      type = model.get('type')

      klass = switch type
              when 'chat' then MF.ChatView
              else MF.EventView

      view = new klass(model: model)

      @subViews.push(view)

      @container.prepend(view.el)
      view.render()

  render: ->
    @container = $(@el).empty()

    for view in @subViews
      @container.append(view.el)
      view.render()
