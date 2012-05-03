#= require collections/facebook_friends_collection
#= require views/facebook_invite_view

class Mf.FacebookConnection extends Backbone.Model
  defaults:
    state: null
    friends: []

  initialize: ->
    FB.getLoginStatus (response) =>
      @setLoginState response

  logIn: ->
    FB.login (response) =>
      @setLoginState response

  setLoginState: (response) ->
    @set 'state', response.status

    if response.status == 'connected'
      @fetchFriends(response.authResponse.accessToken)

  fetchFriends: (accessToken) ->
    collection = new Mf.FacebookFriendsCollection([],
      accessToken: accessToken
    )

    collection.fetch
      success: (friends) => @set 'friends', collection



class Mf.FacebookInvitesView extends Backbone.View
  collection: Mf.FacebookFriendsCollection
  className: 'invites'

  initialize: (options) ->
    @options = options
    @friendUids = options.friendUids
    @inviteUids = options.inviteUids
    @model = new Mf.FacebookConnection()
    @model.bind 'change', @render, @

  events:
    'keydown input.name': 'debouncedSearch'
    'click a.fb-login' : 'logIn'

  template: _.template """
    <h2>Facebook</h2>
    <% if (state == null) {%>
      <p>Loading...</p>
    <% } else if (state == 'not_authorized') {%>
      <a href="javascript:" class="btn fb-login">Authorize Facebook</a>
    <% } else if (state == 'unknown') {%>
      <a href="javascript:" class="btn fb-login">Invite friends from Facebook</a>
    <% } else { %>
      <p>Invite facebook friends to play</p>
      <input class="name" type="text" placeholder="Name" autocomplete="off" />
      <ul class="friends">
      </ul>
    <% } %>
  """

  render: ->
    $(@el).html @template(@model.attributes)
    @renderCollection() if @model.get('friends')

  renderCollection: ->
    $('ul.friends', @el).empty()
    collection = @model.get('friends')

    users = collection
    if @query
      users = collection.filter (user) =>
        user.get('name').toLowerCase().indexOf(@query) != -1

    users.map (user) =>
      friendIsUser = _.find @friendUids, (uid) -> uid == user.get('id')
      friendIsInvited = _.find @inviteUids, (uid) -> uid == user.get('id')

      subView = new Mf.FacebookInviteView
        model: user
        friendIsUser: friendIsUser
        friendIsInvited: friendIsInvited
        inviteUrl: @options.inviteUrl

      $('ul.friends', @el).append(subView.el)
      subView.render()

  search: (e) =>
    # Collapse when esc is pressed
    if e.keyCode is 27
      @collapse(e)
      return

    query = $(e.target).val()
    return if query == @query
    @query = query.toLowerCase()
    @renderCollection()

  debouncedSearch: _.debounce(@::search, 300)

  logIn: ->
    @model.logIn()
