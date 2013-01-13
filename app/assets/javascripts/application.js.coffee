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
#= require jquery.simple-slider
#= require s3upload

#= require ./helpers

#= require_self
#= require_tree .


class window.Application extends Backbone.Router
  routes:
    '': 'home'

  initialize: ->
    $.cookie('time_zone', new Date().getTimezoneOffset())

  home: ->
