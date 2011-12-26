class MF.Event extends Backbone.Model
  
  constructor: (args...) ->
    super(args...)
    
    @__proto__ = switch @get('type')
      when 'chat' then MF.ChatEvent.prototype
      when 'connection' then MF.ConnectionEvent.prototype
      when 'disconnection' then MF.DisconnectionEvent.prototype
    @
  
  url: ->
    "#{window.location.pathname}/events.json"

  isSimilar: (event) -> false
