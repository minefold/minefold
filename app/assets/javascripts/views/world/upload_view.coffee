#= require jquery.s3upload

class Application.WorldUploadView extends Backbone.View
  @maxFileSize: 1 * 1024 * 1024 * 1024 # 1 Gb
  events:
    '.error a.retry': 'retry'

  initialize: (options) ->
    @form = options.form
    @worldUploadPath = options.worldUploadPath

    $(@el).find('input[type=file]').s3upload
      text: options.text
      prefix: options.prefix
      signature_url: options.worldUploadPolicyPath
      submit_on_all_complete: false
      file_types: [['Archives', '*.zip']]

      onselect: @select
      onstart: @start
      onprogress: @progress
      onerror: @error
      oncomplete: @complete
      onrollover: @rollOver
      onrollout: @rollOut

    @button = @$('input#world_path')
    @progress = @$('#progress')

  rollOver: =>
    @button.addClass 'hover'

  rollOut: =>
    @button.removeClass 'hover'

  select: (info, swf) =>
    if parseInt(info.size) < @constructor.maxFileSize
      @progress.find('.filename').text(info.name)
      swf.upload()
      false

  unloadMsg = -> 'Your upload will be lost.'

  start: =>
    @button.hide()

    $(window).on 'beforeunload', unloadMsg

    @progress.attr('class', 'started')
    @form.trigger 'upload:started'

  progress: (progress, info) =>
    percent = "#{Math.floor(progress * 100)}%"
    @progress.find('.bar').css(width: percent).text(percent)
    false

  error: (msg) =>
    @progress.find('.error').text(msg)

    $(window).off 'beforeunload', unloadMsg

    @progress.attr 'class', 'failed'
    @form.trigger 'upload:finished'

  retry: =>
    @progress.attr('class', '')
    @buttn.show()

  complete: (info) =>
    @progress.attr 'class', 'uploaded'

    $.ajax
      type: 'POST'
      url: @worldUploadPath
      data: info
      dataType: 'json'
      success: (data) =>
        channel_name = 'WorldUpload-' + data.id
        channel = Mf.pusher.subscribe(channel_name)

        channel.bind 'success', (data) =>
          @progress.attr 'class', 'succeeded'
          @form.trigger 'upload:finished', data

        channel.bind 'error', @error
