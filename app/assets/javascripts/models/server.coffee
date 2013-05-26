class window.Server extends Backbone.Model

  url: ->
    ['/servers', @get('id'), arguments...].join('/')

  steamConnectUrl: ->
    "steam://connect/#{@get('address')}"
