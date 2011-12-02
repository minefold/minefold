# Copyright 2011 Mutli Inc.

#= require json2
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require jquery.timeago
#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views

delay = (ms, fn) -> setTimeout(fn, ms)
every = (ms, fn) -> setInterval(fn, ms)

jQuery ->
  $('abbr.timeago').timeago()
