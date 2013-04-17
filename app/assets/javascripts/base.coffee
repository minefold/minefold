#= require jquery.cookie

class window.App
  _.extend @prototype, Backbone.Events

  initialize: ->
    $.cookie('time_zone', new Date().getTimezoneOffset())

  setCurrentUser: (data) ->
    @current_user = new App.User(data)


# Makes the Funpack Pickers behave like a checkbox. Just bind to the `changed' event and you should be good to go.
$(document).ready ->
  funpackPicker = $('.funpack-picker')

  funpackPicker.find('.item').click (e) ->
    item = $(this)
    item.siblings().removeClass('active')
    item.addClass('active')

    funpackPicker.trigger('changed', item.data('id'))

  funpackPicker.on 'change', (e, id) ->
    funpackPicker.find(".item[data-id=#{id}]").click()

