#= require models/photo

class Application.FacebookInviteView extends Backbone.View
  model: Application.FacebookUser
  tagName: 'li'
  className: 'friend-to-invite'

  events:
    'click .invite': 'invite'

  template: _.template """
    <img src="https://graph.facebook.com/<%= id %>/picture?type=square" class="avatar" />
    <span class="name"><%= name %></span>
    <% if (this.friendIsInvited) { %>
    <span class="btn disabled">Invite Sent</span>
    <% } else if (!this.friendIsUser) { %>
    <a class="btn invite pull-right" href="javascript:">Invite</a>
    <% } else { %>
    <span class="btn disabled">Already a member</span>
    <% } %>
  """

  initialize: (options) ->
    @friendIsUser = options.friendIsUser
    @friendIsInvited = options.friendIsInvited
    @inviteUrl = options.inviteUrl
    @model.bind 'change', @render, @

  render: ->
    $(@el).html @template(@model.attributes)

  invite: ->
    options =
      to: @model.get('id')
      method: 'send'
      name: 'Join Minefold, play Minecraft'
      description: """
        Minefold lets you create instant Minecraft servers and easily play Minecraft with friends. Using Minefold every world gets a safe and secure home with an awesome map!
      """
      link: @inviteUrl

    # @createInvite()

    FB.ui options, (sent) =>
      if sent
        @createInvite()

  createInvite: ->
    @friendIsInvited = true
    $.post '/invites.json',
      invite:
        facebook_uid: @model.get('id')

    @render()
