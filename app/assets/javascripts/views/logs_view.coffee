class App.LogsView extends Backbone.View
  initialize: (options) ->
    @user = options.u
    @endpoint = options.endpoint
    
  render: =>
    @code = $('pre code', @el)
    @chunkIndex = 0
    
    onChunk = (chunk) =>
      if @chunkIndex == 0
        @code.text('')
      
      lines = chunk.split('\n')
      objs = _.map lines, (line) ->
        $.parseJSON line
        
      objs = _.select objs, (o) -> o
        
      fmtLines = _.map objs, (o) => @toLogFmt(o)
      
      @code.append(fmtLines.join('\n') + '\n')
      @$el.scrollTop(@el.scrollHeight);
      @chunkIndex += 1
      
    onError = (e) =>
      @code.text('Connection Error')
    
    @stream "//#{@endpoint}/servers/1/logs", onChunk, onError


  stream: (url, onChunk, onError) =>
    @onChunk = onChunk
    @onError = onError
    @req = new XMLHttpRequest()
    @req.withCredentials = true
    
    @req.addEventListener("progress", @updateProgress, false)
    @req.addEventListener("load", @transferComplete, false)
    @req.addEventListener("error", @transferFailed, false)
    @req.addEventListener("abort", @transferCanceled, false)

    @prevIndex = 0

    @req.open('GET', url, true, @user)
    @req.send()
    
  updateProgress: (e) => 
    chunk = @req.responseText.substring(@prevIndex, e.position)
    @prevIndex = e.position
    @onChunk(chunk)

  transferFailed: (e) => @onError(e)
  transferComplete: (e) => console.log 'complete', e
  transferCanceled: (e) => console.log 'canceled', e

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