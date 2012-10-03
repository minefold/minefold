#= require 'vector'

class window.Particle
  constructor: (@pos, @vel) ->
    @acc = new Vector(0, 0)
    @ttl = -1
    @lived = 0
  
  move: ->
    @vel.add(@acc)
    @pos.add(@vel)