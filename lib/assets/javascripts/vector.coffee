# Stolen from: https://github.com/jsoverson/JavaScript-Particle-System/blob/master/js/particleSystem/Util.js

class window.Vector
  
  @fromAngle = (angle, magnitude) ->
    new @(magnitude * Math.cos(angle), magnitude * Math.sin(angle))
  
  
  constructor: (@x=0, @y=0) ->

  magnitude: ->
    Math.sqrt(@x * @x + @y * @y)
  
  add: (b) ->
    @x += b.x
    @y += b.y
  
  multiply: (n) ->
    @x *= n
    @y *= n
  
  vectorTo: (b) ->
    new Vector(b.x - @x, b.y - @y)
  
  withinBounds: (pt, size) ->
    @x >= pt.x - size/2 and @x <= pt.x + size/2 and
    @y >= pt.y - size/2 and @y <= pt.y + size/2
  
  angle: ->
    if @x > 0
      if @y > 0
        offset = 0
        ratio = @y / @x
      else
        offset = 3 * Math.PI/2
        ratio = @x / @y
    
    else
      if @y > 0
        offset = Math.PI/2
        ratio = @x / @y
      else
        offset = Math.PI
        ratio = @y / @x
    
    Math.atan(Math.abs(ratio)) + offset
  
  angleDegrees: ->
    @angle() * 180 / Math.PI
  
  jitter: (n) ->
    new Vector(
      @x + @y * n * Math.random(),
      @y + @y * n * Math.random()
    )
  
  clone: ->
    new @constructor(@x, @y)
