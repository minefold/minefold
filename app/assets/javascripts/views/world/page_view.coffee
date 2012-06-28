#= require models/world

class Application.WorldPageView extends Backbone.View
  model: Application.World
  tagName: 'article'

  initialize: (options) ->
    @world = options.world

  enter: ->
  exit: ->

