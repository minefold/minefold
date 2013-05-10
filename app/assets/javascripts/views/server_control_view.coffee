#= require models/server

class window.ServerControlView extends Backbone.View
  model: window.Server

  initialize: ->
    @model.on('change:state', @render)

  render: =>
    btn = switch @model.get('state')
      when 'idle' then @startBtn()
      when 'starting' then @startingBtn()
      when 'up' then @stopBtn()
      when 'stopping' then @startBtn()

    @$el.html(btn)


  startBtn: ->
    $('<a></a>')
      .addClass('btn btn-block btn-primary btn-large')
      .text('Start server')
      .click(@model.start)

  startingBtn: ->
    $('<a></a>')
      .addClass('btn btn-block btn-primary btn-large disabled')
      .text('Starting server...')

  stopBtn: ->
    $('<a></a>')
      .addClass('btn btn-block btn-danger btn-large')
      .text("Stop server")
      .click(@model.stop)
