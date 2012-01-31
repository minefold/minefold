#= require models/photo

class Mf.PhotoView extends Backbone.View
  model: Mf.Photo
  tagName: 'figure'
  className: 'photo'

  template: _.template """
    <img src="<%= src %>"/>
    <figcaption>
      <strong><%= title %></strong>
      <%= caption %>
    </figcaption>
  """

  initialize: ->

  render: ->
    $(@el).html @template(@model.attributes)
