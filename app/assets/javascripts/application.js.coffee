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

#= require ./base
#= require ./helpers
#= require_tree .
#= require_self

window.app = new App()

$(document).ready ->
  Backbone.history.start()
