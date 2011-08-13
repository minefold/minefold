$wallItems = $('#wall-items')

$wallItems.moar
  url: '/worlds/atlassian/wall_items/page/:page'
  onLoad: (items) ->
    for item in items
      console.log item
      console.log $wallItems
      $wallItems.append $(Mustache.renderTemplate('worlds/_wall_item', item))
