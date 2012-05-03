#= require models/world_member

class Mf.WorldMembersCollection extends Backbone.Collection
  model: Mf.WorldMember

  url: ->
    "#{@worldUrl}/players"

  initialize: (models, options) ->
    @worldUrl = options.worldUrl
    
    
