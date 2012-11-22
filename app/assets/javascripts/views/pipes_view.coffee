#= require 'raphael'

class Pt
  constructor: (@x, @y) ->

# --

class Grid
  @Compass =
    n: new Pt( 0, -1)
    e: new Pt( 1,  0)
    s: new Pt( 0,  1)
    w: new Pt(-1,  0)

  constructor: (@width, @height, @scaleX, @scaleY) ->
    @_grid = new Array(@height)
    @_grid[i] = new Array(@width) for i in [0..@height]

  get: (pt) ->
    @_grid[pt.y][pt.x]

  set: (pt, val) ->
    @_grid[pt.y][pt.x] = val

  acquire: (pt) ->
    @set(pt, 1)

  release: (pt) ->
    @set(pt, 0)

  peek: (pt, dir) ->
    d = @constructor.Compass[dir]
    new Pt(pt.x + d.x, pt.y + d.y)

  isInside: (pt) ->
    0 <= pt.x < @width and 0 <= pt.y < @height

  isFree: (pt) ->
    @isInside(pt) and @get(pt) != 1

  isUnbound: (pt) ->
    ( @isFree(@peek(pt, 'n')) or
      @isFree(@peek(pt, 'e')) or
      @isFree(@peek(pt, 's')) or
      @isFree(@peek(pt, 'w'))
    )

# --

class Pipe
  @Dirs = ['n', 'e', 's', 'w']

  @randomDir = ->
    r = Math.random()
    return if r < 0.1
      'n'
    else if 0.1 <= r < 0.3
      'w'
    else if 0.3 <= r < 0.5
      'e'
    else
      's'

  speed: 300
  attrs: ->
    {
      stroke: 'white'
      'stroke-width': 6
      opacity: 0.1 + (Math.random() * 0.1)
    }

  constructor: (@grid, start) ->
    @pts = []
    @add(start)

  add: (pt) ->
    @grid.acquire(pt)
    @pts.push(pt)
    @head = pt

  remove: =>
    @grid.release(pt) for pt in @pts

  seek: ->
    dir = @constructor.randomDir()
    pt = @grid.peek(@head, dir)
    [dir, pt]

  move: ->
    [dir, pt] = @seek()
    if @grid.isFree(pt)
      @add(pt)
    else if @grid.isUnbound(pt)
      @move()

  isAlive: ->
    @grid.isUnbound(@head)

  path: ->
    p = []
    for pt in @pts
      p.push('L')
      p.push(pt.x * @grid.scaleX)
      p.push(pt.y * @grid.scaleY)

    p[0] = 'M'
    p

  draw: (paper) ->
    @elm = paper.path(@path()).attr(@attrs())

  grow: =>
    if @isAlive()
      @move()
      @elm.animate {path: @path()}, @speed, @grow

    else
      @elm.animate {opacity: 0}, @speed * 2, @remove


# --


window.PipesView =
  Pt: Pt
  Grid: Grid
  Pipe: Pipe


# --


paper = Raphael('canvas')

scaleX = 20
scaleY = 12

w = Math.ceil(paper.width / scaleX)
h = Math.ceil(paper.height / scaleY)

grid = new PipesView.Grid(w, h + 1, scaleX, scaleY)

every 500, ->
  pt = new Pt(rand(w), 0)
  if grid.isFree(pt)
    pipe = new PipesView.Pipe(grid, pt)
    pipe.draw(paper)
    pipe.grow()

