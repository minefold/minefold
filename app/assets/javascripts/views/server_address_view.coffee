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

    if @model.get('steamId')?
      @$el.append(@steamConnectLink())

  steamConnectLink: ->
    $('<a></a>')
      .addClass("btn btn-block btn-success")
      .text('Connect to server in game')
      .css(margin: '10px 0')
      .attr(href: "steam://connect/#{@model.get('address')}")

