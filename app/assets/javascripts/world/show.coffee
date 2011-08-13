$wallItems = $('#wall-items')

$wallItems.moar
  url: "#{window.location.pathname}/wall_items/page/:page"
  onLoad: (items) ->
    for item in items
      $wallItems.append $(Mustache.renderTemplate('worlds/_wall_item', item))
