#= require models/event

class MF.ChatEvent extends MF.Event
  defaults:
    type: 'chat'
  
  isSimilar: (previous) ->
    @get('type') is previous.get('type') and
    @get('source').id is previous.get('source').id
