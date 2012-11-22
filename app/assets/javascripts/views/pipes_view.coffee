class Pt
  constructor: (@x, @y) ->

# --

class Grid

  @Compass =
    n: new Pt( 0, -1)
    e: new Pt( 1,  0)
    s: new Pt( 0,  1)
    w: new Pt(-1,  0)

  constructor: (@width, @height) ->
    @_grid = new Array(@height)
    @_grid[i] = new Array(@width) for i in [0..@height]

  get: (pt) ->
    @_grid[pt.y][pt.x]

  set: (pt, val) ->
    @_grid[pt.y][pt.x] = val

  peek: (pt, dir) ->
    d = @constructor.Compass[dir]
    new Pt(pt.x + d.x, pt.y + d.y)

  isInside: (pt) ->
    0 <= pt.x < @width and 0 <= pt.y < @height

  isEmpty: (pt) ->
    @isInside(pt) and not @get(pt)?

  isFree: (pt) ->
    ( @isEmpty(@peek(pt, 'n')) or
      @isEmpty(@peek(pt, 'e')) or
      @isEmpty(@peek(pt, 's')) or
      @isEmpty(@peek(pt, 'w'))
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

  constructor: (@grid) ->
    @pts = []

  add: (pt) ->
    @grid.set(pt, 1)
    @pts.push(pt)
    @head = pt

  seek: ->
    @grid.peek(@head, @constructor.randomDir())

  move: ->
    pt = @seek()
    if @grid.isEmpty(pt)
      @add(pt)
    else if @grid.isFree(pt)
      @move()

  build: ->
    while @grid.isFree(@head)
      @move()

window.PipesView =
  Pt: Pt
  Grid: Grid
  Pipe: Pipe
