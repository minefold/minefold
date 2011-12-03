#= require jquery.timeago
#= require views/event_view

class MF.ChatView extends MF.EventView
  className: 'event'

  template: _.template """
    <div class="avatar">
      <img src="<%= source.avatar %>" width="24" height="24" />
    </div>
    <div class="body">
      <div class="meta">
        <a href="<%= source.url %>"><%= source.username %></a>
        <abbr class="timeago"><%= created_at %></abbr>
      </div>

      <p><%= text %></p>
    </div>
  """

  initialize: (options) ->
    super()

  render: ->
    # TODO: Refactor

    src = @model.get('source') || {}

    attrs =
      text: @model.get('text')
      created_at: @model.get('created_at')
      source:
        id: src.id || '4e1ff77971e2f4000100001e'
        username: src.username || 'chrislloyd'
        avatar: src.avatar ||  '/uploads/user/avatar/4e1ff77971e2f4000100001e/head_s60_chrislloyd.png'
        url: src.url || '/players/chrislloyd'


    $(@el)
      .html @template(attrs)

    # TODO: Make the time a "timeago"
