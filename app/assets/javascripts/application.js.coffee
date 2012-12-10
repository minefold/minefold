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

#= require ./helpers

#= require particle_system

#= require_self
#= require_tree .

#= require ./s3upload


class window.Application extends Backbone.Router
  routes:
    '': 'home'

  initialize: ->
  home: ->
