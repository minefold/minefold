class Application.CoinsView extends Backbone.View
  model: Application.User

  tagName: 'div'
  className: 'cr'

  initialize: ->
    @model.bind 'change:coins', @render, @

  render: ->
    @$el.text(@model.get('coins'))
