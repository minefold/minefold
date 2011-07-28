class window.Invite extends Backbone.Model

  url = '/invite'

  validate: (attrs) ->
    if attrs.email.length is 0
      return "email can't be empty"
