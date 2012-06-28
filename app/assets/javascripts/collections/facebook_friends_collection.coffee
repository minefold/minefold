#= require models/facebook_user

class Application.FacebookFriendsCollection extends Backbone.Collection
  url: -> 'https://graph.facebook.com/me/friends?access_token=' + @accessToken
  model: Application.FacebookUser

  initialize: (models, options) ->
    @accessToken = options.accessToken

  parse: (results) ->
    _.sortBy results.data, (user) -> user.name