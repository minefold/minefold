#= require views/event_view

class Application.ConnectionView extends Application.EventView
  template: _.template """
    <div class="meta">
      <time class="timeago" datetime="<%= created_at %>"></time>
    </div>

    <div class="body">
      <p><%= source.username %> joined the game</p>
    </div>
  """

  initialize: (options) ->
    super()

  render: ->
    attrs = @model.toJSON()

    # TODO: Refactor
    #       This is totally hacky.
    attrs.created_at or= iso8601DateString(new Date())

    attrs.text = _.escape(attrs.text)

    $(@el)
      .html @template(attrs)

    @$('time.timeago').timeago()

  # TODO: Exctract to a helper and fix style
  # From: http://webcloud.se/log/JavaScript-and-ISO-8601
  iso8601DateString = (date) ->
    pad = (n) -> if n < 10 then '0'+n else n

    return date.getUTCFullYear() + '-' +
           pad(date.getUTCMonth()+1) + '-' +
           pad(date.getUTCDate()) + 'T' +
           pad(date.getUTCHours()) + ':' +
           pad(date.getUTCMinutes()) + ':' +
           pad(date.getUTCSeconds()) + 'Z'
