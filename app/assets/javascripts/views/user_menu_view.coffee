class Application.UserMenuView extends Backbone.View
  events:
    'mouseenter': 'show'
    'mouseleave': 'hide'

  show: =>
    $(@el).addClass('is-active')

  hide: =>
    $(@el).removeClass('is-active')
