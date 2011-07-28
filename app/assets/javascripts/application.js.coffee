#= require jquery
#= require jquery_ujs
#= require json2
#= require underscore
#= require backbone

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
