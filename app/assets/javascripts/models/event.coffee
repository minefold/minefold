class Mf.Event extends Backbone.Model
  
  constructor: (args...) ->
    super(args...)
    
    @__proto__ = switch @get('type')
      when 'chat' then Mf.ChatEvent.prototype
      when 'connection' then Mf.ConnectionEvent.prototype
      when 'disconnection' then Mf.DisconnectionEvent.prototype
    @
  
  url: ->
    "#{window.location.pathname}/events.json"

  isSimilar: (event) -> false
