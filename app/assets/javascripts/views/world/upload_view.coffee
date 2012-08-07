#= require jquery.s3upload

class Application.WorldUploadView extends Backbone.View
  @maxFileSize: 1 * 1024 * 1024 * 1024 # 1 Gb

  events:
    'a.retry': 'retry'

  initialize: ({@btnText, @uploadPath, @uploadPrefix, @uploadPolicyPath}) ->

  render: ->
    @$('input[type=file]').s3upload
      text: @btnText
      prefix: @uploadPrefix
      signature_url: @uploadPolicyPath
      submit_on_all_complete: false
      file_types: [['Archives', '*.zip']]

      onselect: @select
      onstart: @start
      onprogress: @progress
      onerror: @error
      oncomplete: @complete
      onrollover: @rollOver
      onrollout: @rollOut

  rollOver: =>
    @$('input[type=file]').addClass 'hover'

  rollOut: =>
    @$('input[type=file]').removeClass 'hover'

  select: (info, swf) =>
    if parseInt(info.size) < @constructor.maxFileSize
      @$('.processing-help-block .filename').text(info.name)
      swf.upload()
      false

  unloadMsg = -> 'Your upload will be lost.'

  start: (a) =>
    @$('.help-block').hide()
    @$('filename').text(a.name)
    @$('input[type=file]').hide()
    # @$('.progress').show()

    # $('#s3upload_world_path object').hide()

    $(window).on 'beforeunload', unloadMsg
    @trigger 'start'

  progress: (progress, info) =>
    percent = "#{Math.floor(progress * 100)}%"
    @$('.progress .bar').css(width: percent)
    false

  error: (msg) =>
    @$('.help-block').hide()
    @$('.help-block-error .reason').text(msg)
    @$('.help-block-error').show()
    @$('.progress').addClass('progress-danger')

    $('#s3upload_world_path').show()

    $(window).off 'beforeunload', unloadMsg

    @trigger 'error'

  retry: (e) =>
    e.preventDefault()
    @$('.progress').removeClass('progress-danger')
    @$('input[type=file]').show()

  complete: (info) =>
    @$('.help-block').hide()
    @$('.processing-help-block').show()

    $.ajax
      type: 'POST'
      url: @uploadPath
      data: info
      dataType: 'json'
      success: (data) =>
        channel_name = 'WorldUpload-' + data.id
        channel = app.pusher.subscribe(channel_name)

        channel.bind 'update', (msg) =>
          @$('.processing-help-block .step').text("(#{msg})")

        channel.bind 'success', (data) =>
          @$('.help-block').hide()
          @$('.progress').addClass('progress-success')
          # @$('.success-help-block').show()
          @trigger 'success', data

        channel.bind 'error', @error
