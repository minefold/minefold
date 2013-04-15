#= require s3upload

class App.UploadView extends Backbone.View
  @maxFileSize: 1 * 1024 * 1024 * 1024 # 1 Gb

  events:
    'change input.upload':    'upload'
    'click input#url-submit': 'urlEntered'

  initialize: ({@sign_url, @post_upload_url, @pusher_chan, @progress_factor}) ->
    channel = window.pusher.subscribe(@pusher_chan)
    channel.bind 'update', (msg) =>
      @$('.processing-help-block .step').text("(#{msg})")

    channel.bind 'success', =>
      @$('.help-block').hide()
      @$('.progress').addClass('progress-success')
      @$('.progress .bar').css(width: "100%").addClass('bar-success')
      @$('.success-help-block').show()
      $(window).off 'beforeunload', unloadMsg

    channel.bind 'error', @error

  render: ->
    @$('.progress').hide()

  upload: (e)->
    filename = $(e.target).val()

    new S3Upload
      s3_object_name: filename
      file_dom_selector: 'input.upload'
      s3_sign_put_url: @sign_url
      onProgress: @progress
      onFinishS3Put: @uploadComplete
      onError: @error

    @start()
  
  urlEntered: ->
    url = @$('input#url').val()
    if !url.match(/\//)
      @$('input#url').parent().addClass('error')
      
    else
      @start()
      @progress(50)
      @uploadComplete(url)

  unloadMsg = -> 'Your upload will be lost.'

  start: () =>
    @$('.upload-controls').hide()
    @$('.help-block').hide()
    @$('input[type=file]').hide()
    @$('.uploading-help-block').show()
    @$('.progress').show().removeClass('progress-danger')

    $(window).on 'beforeunload', unloadMsg
    @trigger 'start'

  progress: (progress, info) =>
    @$('.progress .bar').css(width: "#{progress * @progress_factor}%")
    false

  error: (msg) =>
    @$('upload-controls').show()
    @$('input[type=file]').show()
    @$('.help-block').hide()
    @$('.error-help-block .reason').text(msg)
    @$('.error-help-block').show()
    @$('.progress').addClass('progress-danger')
    @$('.progress .bar').css(width: "100%")

    $(window).off 'beforeunload', unloadMsg

    @trigger 'error'

  uploadComplete: (url) =>
    @$('.help-block').hide()
    @$('.processing-help-block').show()

    $.ajax
      type: 'POST'
      url: @post_upload_url
      data:
        url: url
