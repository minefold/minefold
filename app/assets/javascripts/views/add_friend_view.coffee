#= require underscore

class Mf.AddFriendView extends Backbone.View
  events:
    'click button': 'expand'
    'click a.cancel': 'collapse'
    'keydown input#username': 'debouncedSearch'
    'submit': 'validate'

  initialize: (options) ->
    @searchPath = options.searchPath

  render: ->
    $('input[name=username]').attr('autocomplete', 'off')
    @submit = @$el.find('input[type=submit]').disable()
    @loading = @$el.find('img.loading').hide()

  expand: (e) ->
    e.preventDefault()
    $(@el)
      .addClass('expanded')
      .find('form input').focus()

  collapse: (e) ->
    e.preventDefault()
    $(@el).removeClass('expanded')

  validate: =>
    @form.hasClass('valid') and @form.find('input[name=id]').val().length > 0

  search: (e) =>
    # Collapse when esc is pressed
    if e.keyCode is 27
      @collapse(e)
      return

    username = $(e.target).val()
    return if username == @username
    @username = username

    @submit.disable()
    @loading.show()

    $.ajax
      url: @searchPath
      dataType: 'json'
      data:
        username: username
        ts: new Date().getTime()
      success: (data, status) =>
        @loading.hide()

        unless data.id
          @submit.disable()
        else
          @submit.enable()

          @form
            .addClass('valid')
            .find('input[name=id]').val(data.id)

      error: (xhr, status) =>
        @loading.hide()
        @form.find('input[name=id]').val(null)
        @form.find('.avatar').empty()
        @form.removeClass('valid')

  debouncedSearch: _.debounce(@::search, 300)
