#= require json2
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require mustache
#= require gravtastic
#= require jquery.placeholder
#= require jquery.infinitescroll
#= require_self
#= require_tree .

delay = (ms, fn) -> setTimeout(fn, ms)
every = (ms, fn) -> setInterval(fn, ms)


$(document).ready ->

  # $('#session .account').hover(
  #   (-> $(this).find('.tabs').show()),
  #   (-> $(this).find('.tabs').hide()),
  # )
  #
  # inviteForm = $('form#new_invite')
  # inviteForm.submit (e) ->
  #   $.post inviteForm.attr('action'), inviteForm.serialize(), (data) ->
  #     if data.errors
  #       inviteForm.find('.errors').html (error for field, error of data.errors).join(', ')
  #
  #     else
  #       inviteForm.find('#invite_email').val('')
  #       inviteForm.find('.count').text("#{data.remaining} remaining")
  #
  #   e.preventDefault()
  #
  # every 50, ->
  #   inviteForm.find('input[type=submit]').attr
  #     disabled: (
  #       inviteForm.find('#invite_email').val() is ''  or
  #       parseInt(inviteForm.find('.count').text()) <= 0
  #     )
  #
  #
  # streamForm = $('#stream form')
  #
  # streamForm.submit (e) ->
  #   e.preventDefault()
  #
  #   $.ajax
  #     type: 'POST'
  #     url: streamForm.attr('action')
  #     data: {raw: streamForm.find('textarea').val()}
  #     success: (data) ->
  #       $(Mustache.renderTemplate('worlds/_wall_item', data)).
  #       prependTo($('#stream #wall-items'))
  #     dataType: 'json'
  #
  #   streamForm.find('textarea').val ''
  #
  #
  # streamForm.find('textarea')
  #   .keydown (e) ->
  #     if e.keyCode is 13 and !e.shiftKey and !e.ctrlKey and !e.altKey
  #       e.preventDefault()
  #       streamForm.submit()
  #
  #   .focus ->
  #     streamForm.find('.submit-advice').removeClass('hidden')
  #
  #   .blur ->
  #     streamForm.find('.submit-advice').addClass('hidden')
  #
  # #
  # #
  # #  #channel.bind 'chat:create', (data) ->
  # #  #  item = $('#chat_' + data.id)
  # #  #  console.log data, item
  # #  #
  # #  #  if item.length > 0
  # #  #    item.replaceWith(Mustache.to_html(Mustache.templates['chat-message'], data))
  # #  #  else
  # #  #    $('#wall-items').prepend(Mustache.to_html(Mustache.templates['chat-message'], data));
  #
