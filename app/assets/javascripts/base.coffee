#= require jquery.cookie

class window.App
  _.extend @prototype, Backbone.Events

  initialize: ->
    $.cookie('time_zone', new Date().getTimezoneOffset())

  setCurrentUser: (data) ->
    @current_user = new App.User(data)
