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
#= require zero-clipboard

#= require ./config

#= require ./base
#= require ./helpers
#= require_tree .
#= require_self

class window.Application
  _.extend @prototype, Backbone.Events

  initialize: ->
    $.cookie('time_zone', new Date().getTimezoneOffset())

  setCurrentUser: (data) ->
    @currentUser = new User(data)

window.app = new Application()
