class App.Server extends Backbone.Model

  initialize: ->
    @channel = pusher.subscribe("server-#{@get('id')}")
    @channel.bind('server:started', @started)
    @channel.bind('server:stopped', @stopped)

  url: ->
    ['/servers', @get('id'), arguments...].join('/')

  start: =>
    $.ajax(
      type: 'POST'
      url: @url('start')
      dataType: 'json'
      success: (data) => @set(data)
    )

  started: (data) =>
    @set(data)

  stop: =>
    $.ajax(
      type: 'POST'
      url: @url('stop')
      dataType: 'json'
      success: (data) => @set(data)
    )

  stopped: (data) =>
    @set(data)

  steamConnectLink: ->
    "steam://connect/#{@get('address')}"
