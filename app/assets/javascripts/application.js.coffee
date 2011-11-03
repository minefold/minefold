#= require json2
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require mustache
#= require jquery.placeholder
#= require jquery.infinitescroll
#= require jquery.autocomplete
#= require fancybox
#= require ./templates
#= require_self
#= require_tree .

delay = (ms, fn) -> setTimeout(fn, ms)
every = (ms, fn) -> setInterval(fn, ms)
