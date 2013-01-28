#= require models/server

class App.ServerAddressView extends Backbone.View
  model: App.Server

  initialize: ->
    @model.on('change:address', @render)

  render: =>
    if @model.get('address')? and @model.get('address') != ''
      @$el.removeClass('muted').text(@model.get('address'))
    else
      @$el.addClass('muted').text("No address")
