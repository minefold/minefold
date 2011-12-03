#= require collections/events_collection
#= require models/chat

class MF.ShareView extends Backbone.View
  collection: MF.EventsCollection

  events:
    'keyup':  'type'
    'submit': 'submit'

  submit: (e) -> false

  type: (e) =>
    input = $(e.target)

    if isEnterKey(e) and input.val() isnt ''
      e.preventDefault()

      chat = new MF.Chat(text: input.val())
      @collection.add(chat)
      chat.save()

      input.val('')


  isEnterKey = (event) ->
    event.keyCode is 13 and
      not event.ctrlKey and
      not event.altKey and
      not event.metaKey and
      not event.shiftKey
