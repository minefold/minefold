#= require models/user

class Application.CreditsBarView extends Backbone.View
  model: Application.User

  initialize: ->
    @model.on('change', @render)

  render: =>
    cr = @model.get('credits')
    threshold = @model.get('credit_threshold')
    pro = @model.get('pro')



    if pro
      @$el.addClass('is-pro')

    else
      if cr <= threshold
        percent = cr / threshold
        @$('.bar').css(width: "#{percent * 100}%")

        if percent <= 0.15
          @$el.addClass('is-empty')
        else if percent <= 0.30
          @$el.addClass('is-low')

      else
        @$el.addClass('is-full')
        @$('.bar').css(width: '100%')
        percent = 1 - (threshold / cr)
        @$('.overflow').css(width: "#{percent * 100}%")

