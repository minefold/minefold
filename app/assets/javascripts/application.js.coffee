###!
  Minefold
  https://minefold.com

  Copyright 2011 Mütli Corp.
###

#= require json2
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require bootstrap

#= require jquery.cookie
#= require s3upload

#= require ./base
#= require ./helpers
#= require_tree .
#= require_self

class window.Application
  _.extend @prototype, Backbone.Events

  initialize: ->
    $.cookie('time_zone', new Date().getTimezoneOffset())

  setCurrentUser: (data) ->
    @current_user = new User(data)

window.app = new Application()
