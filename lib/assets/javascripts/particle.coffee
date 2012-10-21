#= require 'vector'

class window.Particle extends Backbone.View
  className: 'particle'
  
  initialize: (@pos, @vel) ->
    @acc = new Vector(0, 0)
    @ttl = 10
    @lived = 0
  
  move: ->
    @vel.add(@acc)
    @pos.add(@vel)
