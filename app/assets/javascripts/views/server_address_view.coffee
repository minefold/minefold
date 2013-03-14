#= require models/server

class App.ServerAddressView extends Backbone.View
  model: App.Server
  
  events:
    'click input.server-address': 'click'

  initialize: ->
    @model.on('change:address', @render)

  render: =>
    connectBtn = @$('.btn.connect')
    address = @$('.server-address')
        
    if address.val()? and address.val() != ''
      address.popover()
      @$el.addClass('is-connectable')
      address.text(@model.get('address'))
      connectBtn.attr(href: @model.steamConnectUrl())
      connectBtn.show()

    else
      @$el.removeClass('is-connectable')
      address.val("No address")
      connectBtn.hide()

    if !@model.get('steamId')?
      connectBtn.hide()

  click: =>
    @$('.server-address').select()