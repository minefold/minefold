#= require models/server

class App.ServerAddressView extends Backbone.View
  model: App.Server
  
  events:
    'click input.server-address': 'click'

  initialize: ->
    @model.on('change:address', @render)

  render: =>
    address = @$('.server-address').popover()
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

  click: =>
    @$('.server-address').select()
    
  selectText: (element) ->
      if document.body.createTextRange # ie
          range = document.body.createTextRange()
          range.moveToElementText(element)
          range.select()
      else if window.getSelection # moz, opera, webkit
          selection = window.getSelection()
          range = document.createRange()
          range.selectNodeContents(element)
          selection.removeAllRanges()
          selection.addRange(range)
