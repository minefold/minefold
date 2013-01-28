class App.Map extends Backbone.Model

  assetsUrl: ->
    [@get('host'), @get('serverId')].join('/')
