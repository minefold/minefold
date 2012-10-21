#= require particle
#= require particle_emitter

class window.ParticleSystem
  @maxParticles = 2000
  
  constructor: ({@view})->
    @particles = []
    @emitters = []
    @elapsed = 0
  
  
  addEmitter: (x, y) ->
    @emitters.push(new ParticleEmitter(
      new Vector(x, y),
      new Vector(0, 1))
    )
  
  tick: ->
    @elapsed += 1
    
    # Add new particles
    if @particles.length < @constructor.maxParticles
      for emitter in @emitters
        for _ in [0...emitter.emissionRate]
          p = emitter.createParticle()
          @particles.push(p)
          @view.addParticle(p)
    
    # Plot particles
    newParticles = []
    
    while particle = @particles.pop()
      console.log particle.ttl
      
      if particle.ttl > 0
        particle.lived += 1
        
        # Kill particles that have outlived their ttl
        if particle.lived >= particle.ttl
          particle.remove()
          continue
        
      particle.move()
      
      newParticles.push(particle)
    
    @particles = newParticles
