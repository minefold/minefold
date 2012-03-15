attributes :id, :created_at, :updated_at, :last_mapped_at, :map_assets_url, :map_data, :host

node(:url) {|world| player_world_url(world.creator.minecraft_player, world) }

child(world.creator.minecraft_player => :creator) {
  extends 'players/_base'
}

child(world.players => :players) {
  extends 'players/_base'
  node(:op, if: ->(u){ world.opped_players.include?(u)}) { true }
}
