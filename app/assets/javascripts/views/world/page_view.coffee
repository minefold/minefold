#= require models/world

class Mf.WorldPageView extends Backbone.View
  model: Mf.World
  tagName: 'article'

  initialize: (options) ->
    @world = options.world

  enter: ->
  exit: ->

