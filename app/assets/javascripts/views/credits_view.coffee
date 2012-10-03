class Application.CreditsView extends Backbone.View
  model: Application.User
  
  tagName: 'div'
  className: 'cr'

  initialize: ->
    @model.bind 'change:credits', @render, @

  render: ->
    @$el.text(@model.get('credits'))
