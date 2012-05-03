#= require models/photo

class Mf.FriendAddView extends Backbone.View
  model: Mf.WorldMember
  tagName: 'li'
  className: 'friend'

  events:
    'click .add': 'add'

  template: _.template """
    <img src="<%= avatar_url %>" />
    <span class="name"><%= username %></span>
    <% if (added) { %>
    <span class="btn disabled">Added</a>
    <% } else { %>
    <a class="btn add" href="javascript:">Add</a>
    <% } %>
  """

  initialize: ->
    @model.bind 'change', @render, @

  render: ->
    $(@el).html @template(@model.attributes)

  add: ->
    @model.add()
