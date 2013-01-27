#= require 'raphael'

# Picks a random key from an object whose values are weights
weightedRandom = (weights) ->
  vals = _.keys(weights)

  # console.log weights

  limit = _.chain(weights).values().inject(((i, sum) -> sum + i), 0).value()

  r = Math.random() * limit

  sortedPairs = _.chain(weights).pairs().sortBy((p) -> p[1]).value()

  mark = 0

  for [val, weight] in sortedPairs
    mark += weight
    return val if r <= mark

# --

class Pt
  constructor: (@x, @y) ->

# --

class Grid
  @Compass =
    n: new Pt( 0, -1)
    e: new Pt( 1,  0)
    s: new Pt( 0,  1)
    w: new Pt(-1,  0)

  @Dirs = _.keys(@Compass)

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

  @DirWeights = {
    n: 0.1
    e: 0.2
    s: 0.5
    w: 0.2
  }

  speed: 600

  attrs: ->
    {
      stroke: 'white'
      'stroke-width': 6
      opacity: 0.05 + (Math.random() * 0.2)
    }

  constructor: (@grid, start) ->
    @pts = []
    @add(start)
    @lastDir = 's'

  add: (pt) ->
    @grid.acquire(pt)
    @pts.push(pt)
    @head = pt

  remove: =>
    @grid.release(pt) for pt in @pts
    @elm.remove()

  move: (space) ->
    space or= (
      keys = _.keys(@constructor.DirWeights)
      i = _.indexOf(keys, @lastDir)
      keys.splice((i + 2) % keys.length, 1)
      keys
    )

    # Pick a direction
    dir = weightedRandom(_.pick(@constructor.DirWeights, space...))

    pt = @grid.peek(@head, dir)

    if @grid.isFree(pt)
      @lastDir = dir
      @add(pt)

    else if @grid.isUnbound(pt)
      # Removes the pt from the search space
      i = _.indexOf(space, dir)
      space.splice(i, 1)

      # Try again with the smaller search space
      @move(space)


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


App.PipesView =
  Pt: Pt
  Grid: Grid
  Pipe: Pipe

