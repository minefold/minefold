require './lib/game_library'
require './lib/game'
require './lib/games/minecraft'
require './lib/games/team_fortress_2'

GAMES = GameLibrary.new

GAMES.push Minecraft.new(
  id: 1,
  name: 'Minecraft',
  slug: 'minecraft',
  funpack_id: 1,
  published_at: DateTime.new(2011, 4, 1),
  url: 'https://minecraft.net/store'
)

GAMES.push TeamFortress2.new(
  id: 2,
  name: 'Team Fortress 2',
  slug: 'team-fortress-2',
  funpack_id: 4,
  published_at: DateTime.new(2012, 2, 8),
  url: 'http://store.steampowered.com/app/440'
)

GAMES.push Game.new(
  id: 3,
  name: 'Counter-Strike',
  slug: 'counter-strike'
)

GAMES.push Game.new(
  id: 4,
  name: 'Call of Duty',
  slug: 'call-of-duty'
)

GAMES.push Game.new(
  id: 5,
  name: 'Battlefield 3',
  slug: 'battlefield-3'
)

GAMES.push Game.new(
  id: 6,
  name: 'DayZ',
  slug: 'day-z'
)
