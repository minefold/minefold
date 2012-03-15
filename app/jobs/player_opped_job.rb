class PlayerOppedJob < Job
  @queue = :low

  def initialize(world_id, op_username, username)
    @world = World.find(world_id)
    @op = MinecraftPlayer.find_by_username(op_username)
    @player = MinecraftPlayer.find_or_create_by(username: username)
  end

  def perform?
    @world.opped_players.include?(@op)
  end

  def perform!
    @world.add_to_set :opped_player_ids, @player.id
  end

end
