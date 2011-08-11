#= require jquery
#= require jquery_ujs
#= require json2
#= require mustache
#= require underscore
#= require backbone
#= require gravtastic
#= require_tree .

delay = (ms, fn) -> setTimeout(fn, ms)
every = (ms, fn) -> setInterval(fn, ms)

$(document).ready ->
  Mustache.templates = {}
  $('#templates script').each ->
    name = $(@).attr('id').replace('template-', '')
    Mustache.templates[name] = $(@).html()

  $('#session .account').hover(
    (-> $(this).find('.tabs').show()),
    (-> $(this).find('.tabs').hide()),
  )

  inviteForm = $('form#new_invite')
  inviteForm.submit (e) ->
    $.post inviteForm.attr('action'), inviteForm.serialize(), (data) ->
      if data.errors
        console.log data.errors
        inviteForm.find('.error').text data.errors
      else
        inviteForm.find('#invite_email').val('')
        inviteForm.find('.count').text(data.invites)

    e.preventDefault()

  every 50, ->
    inviteForm.find('input[type=submit]').attr
      disabled: (
        inviteForm.find('#invite_email').val() is ''  or
        parseInt(inviteForm.find('.count').text()) <= 0
      )


  f = $('#stream form')

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
    console.log data, item

    if item.length > 0
      item.replaceWith(Mustache.to_html(Mustache.templates['chat-message'], data))
    else
      $('#wall-items').prepend(Mustache.to_html(Mustache.templates['chat-message'], data));

