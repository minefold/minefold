class Mf.WorldMapControlView extends Backbone.View
  className: 'world-map-control-view'
  events:
    'click .enter-fullscreen': 'enterFullscreen'
    'click .exit-fullscreen': 'exitFullscreen'

  template: _.template """
    <a class="enter-fullscreen">Fullscreen</a>
    <a class="exit-fullscreen">Leave Fullscreen</a>
  """

  initialize: (options) ->
    @mapView = options.mapView

  render: ->
    @$el.html @template()

  enterFullscreen: ->
    @mapView.enterFullscreen()

  exitFullscreen: ->
    @mapView.exitFullscreen()
