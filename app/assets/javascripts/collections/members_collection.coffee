#= require models/user

class MF.MembersCollection extends Backbone.Collection
  model: MF.User
  
  url: ->
    "#{window.location.pathname}/members.json"
