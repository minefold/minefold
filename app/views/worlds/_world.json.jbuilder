json.url player_world_url(world.creator.minecraft_player, world)

json.extract! world,
  :id, :created_at, :updated_at, :last_mapped_at, :map_assets_url, :map_data, :host

json.creator do |json|
  json.partial! 'players/player', player: world.creator.minecraft_player
end

json.players(world.players) do |json, player|
  json.partial! 'players/player', player: player
  json.op(true) if world.opped_players.include?(player)
end
