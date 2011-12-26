class MF.EventView extends Backbone.View
  className: 'event'

  initialize: (options) ->
    $(@el)
      .addClass(@model.get('type'))
      .attr(id: @model.id)
  