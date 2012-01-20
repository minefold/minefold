#= require underscore

class Mf.AddFriendView extends Backbone.View
  events:
    'click button': 'expand'
    'click a.cancel': 'collapse'
    'keydown form input': 'debouncedSearch'
    'submit form': 'validate'
  
  initialize: (options) ->
    @searchPath = options.searchPath
    @form = @$('form')
  
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
    $.ajax
      url: @searchPath
      dataType: 'json'
      data:
        username: username
      success: (data, status) =>
        img = @form.find('.avatar img')
        if img.length is 0
          img = $('<img />')
            .attr(width: 24, height: 24)
            .appendTo(@form.find('.avatar'))
        
        img.attr 'src', data.avatar.s24.url
        
        @form
          .addClass('valid')
          .find('input[name=id]').val(data.id)
        
      error: (xhr, status) =>
        @form.find('input[name=id]').val(null)
        @form.find('.avatar').empty()
        @form.removeClass('valid')
  
  debouncedSearch: _.debounce(@::search, 300)
