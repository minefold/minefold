#= require models/user

class Mf.MembersCollection extends Backbone.Collection
  model: Mf.User
  
  url: ->
    "#{window.location.pathname}/members.json"
