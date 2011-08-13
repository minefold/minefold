$ = jQuery

$.fn.moar = (options) ->
  options = $.extend {
    url: '/page/:page'
    load: (data) -> console.log data
    scrollMargin: 50
    startPage: 1
    loadingImage: '/images/spinner.gif'
  }, options

  # Preload loading image
  loadingImage = (new Image()).src = options.loadingImage

  @each ->
    $loading = $("<img src='#{options.loadingImage}' />");

    currentPage = options.startPage + 1
    paging = false

    finishedLoading = ->
      paging = false
      $loading.remove()

    $(window).scroll =>
      return if paging
      if $(window).scrollTop() > $(document).height() - $(window).height() - options.scrollMargin
        paging = true
        $loading.appendTo(@);
        $.ajax
          url: options.url.replace(':page', currentPage)
          dataType: 'json'
          success: (data) ->
            currentPage += 1
            options.onLoad(data)
            finishedLoading()
          error: ->
            finishedLoading()
