require './lib/game_library'
require './lib/game'
require './lib/games/minecraft'
require './lib/games/team_fortress_2'

GAMES = GameLibrary.new

GAMES.push Minecraft.new(
  id: 1,
  name: 'Minecraft',
  slug: 'minecraft'
)

GAMES.push TeamFortress2.new(
  id: 2,
  name: 'Team Fortress 2',
  slug: 'tf2'
)
