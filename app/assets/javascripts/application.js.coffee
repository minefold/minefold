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
#= require jquery.elastic
#= require jquery.autoGrowInput

#= require_self
#= require ./helpers
#= require_tree .

class window.Application extends Backbone.Router
  routes:
    '': 'home'

  initialize: ->
    userMenuView = new Application.UserMenuView(
      el: $('.user-menu-view')
    )

  home: ->

