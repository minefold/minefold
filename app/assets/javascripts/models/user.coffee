class Application.User extends Backbone.Model
  initialize: ->
    @chan = window.pusher.subscribe("private-user-#{@get('id')}")
    @chan.bind 'change:credits', (credits) =>
      @set('credits', credits)
