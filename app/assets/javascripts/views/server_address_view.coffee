#= require models/server

class App.ServerAddressView extends Backbone.View
  model: App.Server

  initialize: ->
    @model.on('change:address', @render)

  render: =>
    address = @$('.server-address')
    connectBtn = @$('.btn.connect')

    if @model.get('address')? and @model.get('address') != ''
      @$el.addClass('is-connectable')
      address.text(@model.get('address'))
      connectBtn.attr(href: @model.steamConnectUrl())

    else
      @$el.removeClass('is-connectable')
      address.text("No address")
      connectBtn.attr(href: null)

    connectBtn.toggle(@model.get('steamId')?)
