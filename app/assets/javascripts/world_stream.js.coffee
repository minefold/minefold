$ = jQuery

$.fn.worldStream = ->
  @each ->
    f = $('form', @)

    f.submit (e) ->
      e.preventDefault()

      $.ajax
        type: 'POST'
        url: f.attr('action')
        data: 
          body: f.find('textarea').val()
        success: (data) -> 
          $('#wall-items').prepend Mustache.to_html(Mustache.templates['chat-message'], data)
        dataType: 'json'

      f.find('textarea').val ''


    f.find('textarea')
      .keydown (e) ->
        if e.keyCode is 13 and !e.shiftKey and !e.ctrlKey and !e.altKey
          e.preventDefault()
          f.submit()

      .focus ->
        f.find('.submit-advice').removeClass('hidden')

      .blur ->
          f.find('.submit-advice').addClass('hidden')


    channel.bind 'chat:create', (data) ->
      item = $('#chat_' + data.id)

      if item.length > 0
        item.replaceWith(Mustache.to_html(Mustache.templates['chat-message'], data))
      else
        $('#wall-items').prepend(Mustache.to_html(Mustache.templates['chat-message'], data));
    