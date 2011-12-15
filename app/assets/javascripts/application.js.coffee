# Copyright 2011 Mutli Inc.

#= require json2
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require jquery.timeago
#= require jquery.s3upload
#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views

window.MF = {}

window.delay = (ms, fn) -> setTimeout(fn, ms)
window.every = (ms, fn) -> setInterval(fn, ms)

jQuery ->
  $('time.timeago').timeago()
