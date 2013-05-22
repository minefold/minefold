$(document).ready ->
  clipboard = new ZeroClipboard.Client("[data-clipboard-text]")
  clipboard.on 'complete', ->
    $this = $(this)
    $this.addClass('is-copied')
    delay 4000, ->
      $this.removeClass('is-copied')
