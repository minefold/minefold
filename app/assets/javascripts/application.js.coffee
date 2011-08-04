#= require jquery
#= require jquery_ujs
#= require json2
#= require underscore
#= require backbone
#= require gravtastic
#= require_tree .

delay = (ms, fn) -> setTimeout(fn, ms)
every = (ms, fn) -> setInterval(fn, ms)

$(document).ready ->

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

    body = f.find('textarea').val()
    $.post f.attr('action'), body: body
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
    item = $('<div/>').addClass('item').addClass('chat')

    gravatarUrl = Gravtastic(data['user']['email'], size: 36)

    item.append(
      $('<div/>').addClass('avatar').append(
        $('<img/>').attr(src: gravatarUrl, width: 36, height: 36)
      )
    ).append(
      $('<div/>').addClass('user').append(
        $('<span/>').addClass('username').text(data['user']['username'])
      )
    ).append(
      $('<div/>').addClass('bodyg').text(data['body'])
    ).insertAfter(f)

