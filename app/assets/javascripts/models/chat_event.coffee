#= require models/event

class Mf.ChatEvent extends Mf.Event
  defaults:
    type: 'chat'
  
  isSimilar: (previous) ->
    @get('type') is previous.get('type') and
    @get('source').id is previous.get('source').id
