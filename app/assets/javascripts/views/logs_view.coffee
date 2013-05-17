class window.LogsView extends Backbone.View
  initialize: (options) ->
    @user = options.u
    @serverId = options.serverId
    @endpoint = options.endpoint

  render: =>
    @chunkIndex = 0

    @streamLogs()

  streamLogs: () =>
    @stream "//#{@endpoint}/servers/#{@serverId}/logs", @onChunk, @reconnect, @reconnect

  onChunk: (chunk) =>
    if @chunkIndex == 0
      @$el.empty()

    fmtLines = @parseChunk(chunk)

    @$el.append(fmtLines.join('\n') + '\n')
    @$el.scrollTop(@el.scrollHeight);
    @chunkIndex += 1

  parseChunk: (chunk) =>
    lines = chunk.split('\n')
    objs = _.map lines, (line) ->
      $.parseJSON line

    objs = _.select objs, (o) -> o

    _.map objs, (o) => @toLogFmt(o)

  stream: (url, onChunk) =>
    @url = url
    @onChunk = onChunk
    @prevIndex = 0
    @connect()

  connect: () =>
    @req = new XMLHttpRequest()
    @req.withCredentials = true

    @req.addEventListener("progress", @updateProgress, false)
    @req.addEventListener("load", @reconnect, false)
    @req.addEventListener("error", @reconnect, false)

    @req.open('GET', @url, true, @user)
    @req.send()

  reconnect: () =>
    delay 1000, () => @connect()

  updateProgress: (e) =>
    console.log('progress')
    if e.position > @prevIndex
      chunk = @req.responseText.substring(@prevIndex, e.position)
      @prevIndex = e.position
      @onChunk(chunk)


  toLogFmt: (o) =>
    tsDate = Date.parse(o.ts)
    if tsDate
      ts = "<span class=\"ts\">#{tsDate.toString('yyyy-MM-dd hh:mm:ss')}</span>"
    else
      ts = ''
    delete o.ts

    event = o.event
    delete o.event

    if event == 'chat'
      "#{ts} &lt;#{o.nick}&gt; #{o.msg}"
    else if event == 'info'
      "#{ts} #{o.msg}"

    else
      parts = _.keys(o).map (key) ->
        "#{key}=#{o[key]}"

      "#{ts} <span class=\"event #{event}\">#{event}</span> #{parts.join(' ')}"
