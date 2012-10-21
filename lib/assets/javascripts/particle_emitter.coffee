#= require 'vector'

class window.ParticleEmitter
  
  constructor: (@pos, @vel) ->
    @size         = 8
    @ttl          = 10
    @spread       = Math.PI / 32
    @emissionRate = 1
  
  createParticle: ->
    p = new Particle(
      @pos.clone(),
      # new Vector(3, 1))
      Vector.fromAngle(
        @vel.angle() + @spread - rand(@spread * 2), 
        @vel.magnitude()))
    
    p.ttl = @ttl
    p
