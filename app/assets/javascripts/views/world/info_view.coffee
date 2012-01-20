#= require ./page_view

class Mf.WorldInfoView extends Mf.WorldPageView
  className: 'info'

  enter: ->
    $(@el).parent().show()
    # $(@el).show()

  render: =>
    $(@el).text @model.get('desc')

  exit: ->
    $(@el).parent().hide()
