class window.Server extends Backbone.Model

  url: ->
    ['/servers', @get('id'), arguments...].join('/')

  start: =>
    $.ajax(
      type: 'POST'
      url: @url('start')
      dataType: 'json'
      success: (data) => @set(data)
    )

  onStarted: (data) =>
    @set(data)

  stop: =>
    $.ajax(
      type: 'POST'
      url: @url('stop')
      dataType: 'json'
      success: (data) => @set(data)
    )

  onStopped: (data) =>
    @set(data)

  steamConnectUrl: ->
    "steam://connect/#{@get('address')}"
