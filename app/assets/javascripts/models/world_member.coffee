class Application.WorldMember extends Backbone.Model
  defaults: ->
    added: false

  add: ->
    unless @added
      @set 'added', true
      $.post(@collection.url(), {
        username: @get 'username'
      })
