#= require particle_system

class Application.ParticleSystemView extends Backbone.View
  @className: 'particle-system'
  
  initialize: ->
    @system = new ParticleSystem(view: @)
    
    # for i in [1..100]
    #   pos = new Vector(rand(100), rand(100))
    #   acc = new Vector(rand(10), rand(10))
    #   
    #   particle = new Particle(pos, acc)
    # 
    #   @system.particles.push particle
    #   
    #   @$el.append(particle.el)
  
  addParticle: (particle) ->
    @$el.append(particle.el)
  
  render: =>
    window.requestAnimationFrame =>
      @system.tick()
      
      for particle in @system.particles
        particle.$el.css(
          top: particle.pos.y, left: particle.pos.x
        )
      
      @render()
