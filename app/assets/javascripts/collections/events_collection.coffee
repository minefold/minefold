#= require models/event

class MF.EventsCollection extends Backbone.Collection
  model: MF.Event

  url: ->
    "#{window.location.pathname}/events.json"
  
  parse: (events) ->
    events.reverse()
  