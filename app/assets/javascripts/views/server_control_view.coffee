#= require models/server

class window.ServerControlView extends Backbone.View
  model: window.Server
  className: 'server-control'

  events:
    '.btn.btn-block': 'start'

  initialize: ->
    @listenTo @model, 'change', @render

  render: =>
    @$el
      .attr('data-state', @model.get('state'))
      .html JST['templates/server_control_view'](server: @model)

  start: (e) ->
    $(e.target).attr('disabled', true)

