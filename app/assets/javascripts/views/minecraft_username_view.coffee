class MF.MinecraftUsernameView extends Backbone.View
  events:
    'keyup': 'debouncedCheck'

  initialize: ->
    @hint = $(@el).siblings('.hint')

  check: =>
    val = $(@el).val()

    if val is ''
      @hint.hide()
    else
      $.getJSON '/signup/check', {username: val}, (data, status) =>
        @hint.toggle(not data.paid)


  debouncedCheck: _.debounce(@::check, 300)
