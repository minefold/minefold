#= require models/photo

class Application.FriendAddView extends Backbone.View
  model: Application.WorldMember
  tagName: 'li'
  className: 'friend-to-invite'

  events:
    'click .add': 'add'

  template: _.template """
    <img src="<%= avatar_url %>" class="avatar" />
    <span class="name"><%= username %></span>
    <% if (added) { %>
    <span class="btn disabled pull-right">Added</a>
    <% } else { %>
    <a class="btn add pull-right" href="javascript:">Add</a>
    <% } %>
  """

  initialize: ->
    @model.bind 'change', @render, @

  render: ->
    $(@el).html @template(@model.attributes)

  add: ->
    @model.add()
