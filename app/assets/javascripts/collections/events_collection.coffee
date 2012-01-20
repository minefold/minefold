#= require models/event

class Mf.EventsCollection extends Backbone.Collection
  model: Mf.Event

  url: ->
    "#{window.location.pathname}/events.json"
  
  parse: (events) ->
    events.reverse()
  