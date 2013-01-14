require './lib/game_library'
require './lib/game'
require './lib/games/minecraft'

GAMES = GameLibrary.new

GAMES.push Minecraft.new(
  id: 1,
  name: 'Minecraft',
  slug: 'minecraft'
)
