#= require collections/world_members_collection
#= require views/friend_add_view

class Application.FriendsAddView extends Backbone.View
  collection: Application.WorldMembersCollection
  className: 'friends'

  initialize: (options) ->
    @collection = options.friends

  events:
    'keydown input.name': 'debouncedSearch'

  template: _.template """
    <h2>Minefold</h2>
    <p>Add minefold players to your world</p>
    <input class="name" type="text" placeholder="Username" autocomplete="off" />
    <ul class="friends unstyled">
    </ul>
  """

  render: ->
    $(@el).html @template()
    @renderCollection()

  renderCollection: ->
    $('ul.friends', @el).empty()
    users = @collection
    if @query
      users = @collection.filter (user) =>
        user.get('username').toLowerCase().indexOf(@query) != -1

    users.map (player) =>
      subView = new Application.FriendAddView(model: player)
      $('ul.friends', @el).append(subView.el)
      subView.render()

  search: (e) =>
    query = $(e.target).val()
    return if query == @query
    @query = query.toLowerCase()
    @renderCollection()

  debouncedSearch: _.debounce(@::search, 300)
