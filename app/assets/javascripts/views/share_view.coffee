#= require collections/events_collection
#= require models/chat

class MF.ShareView extends Backbone.View
  collection: MF.EventsCollection

  events:
    'keyup':  'type'
    'submit': 'submit'

  submit: (e) -> false

  type: (e) =>
    if e.keyCode is 13
      e.preventDefault()

      input = $(@el).find('input[name=text]')

      text = input.val()

      chat = new MF.Chat(text: text)

      @collection.add(chat)

      chat.save()

      input.val('')

