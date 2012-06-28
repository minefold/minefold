#= require ./page_view

class Application.WorldInfoView extends Application.WorldPageView
  className: 'info'

  enter: ->
    $(@el).parent().show()
    # $(@el).show()

  render: =>
    $(@el).text @model.get('desc')

  exit: ->
    $(@el).parent().hide()
