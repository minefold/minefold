#= require jquery.s3upload

class Mf.WorldUploadView extends Backbone.View
  @maxFileSize: 1 * 1024 * 1024 * 1024 # 1 Gb

  initialize: (options) ->
    @worldUploadPath = options.worldUploadPath

    $(@el).find('input[type=file]').s3upload
      prefix: options.prefix
      text: options.text
      signature_url: options.signature_url
      submit_on_all_complete: false
      onselect: @select
      onstart: @start
      onprogress: @progress
      onrollover: @rollOver
      onrollout: @rollOut

    @button = $(@el).find('input#world_path')

  select: (info, swf) =>
    if parseInt(info.size) < @constructor.maxFileSize
      swf.upload()
      $('#world_upload_path').val "Uploading #{info.name}"
      false

  rollOver: => @button.addClass 'hover'
  rollOut: => @button.removeClass 'hover'

  start: =>
    $('p.state').hide()
    $('.progress').show()
    $('.status').show()
    # trigger 'upload-in-progress'

  progress: (progress, info) =>
    percent = Math.floor(progress * 100)
    $('form .progress .bar').css width: "#{percent}%"
    $('.status').text "#{percent}%"
    false

  error: (msg) =>
    $('.status').addClass('error').text(msg)
    # trigger 'upload-failed'

  complete: (info) =>
    $('.progress').add($('.status')).slideUp()
    $('#world_upload_path').val('Processing...')
    $('form .processing').show()

    $.ajax
      type: 'POST'
      url: @worldUploadPath
      data: info
      dataType: 'json'
      success: (data) ->
        channel_name = 'WorldUpload-' + data.id
        channel = Mf.pusher.subscribe(channel_name)

        channel.bind 'success', (data) ->
          $('p.state').hide()
          $('#world_upload_path').val('Finished')
          $('input#world_world_upload_id').val(data.world_upload.id)
          # uploadForm.trigger 'upload-succeeded'

        channel.bind 'error', (message) ->
          $('p.state').hide()
          $('#world_upload_path').val('Upload your world')
          $('.error .message').text(message)
          $('.error').show()
          $('.note').show()
          # form.trigger 'upload-failed'
