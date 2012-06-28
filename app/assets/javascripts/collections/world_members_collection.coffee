#= require models/world_member

class Application.WorldMembersCollection extends Backbone.Collection
  model: Application.WorldMember

  url: ->
    "#{@worldUrl}/players"

  initialize: (models, options) ->
    @worldUrl = options.worldUrl


