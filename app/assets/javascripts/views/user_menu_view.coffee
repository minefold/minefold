class MF.UserMenuView extends Backbone.View
  events:
    'mouseenter': 'show'
    'mouseleave': 'hide'

  show: =>
    $(@el).addClass 'active'

  hide: =>
    $(@el).removeClass 'active'
