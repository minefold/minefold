class OpActionJob < Job
  def initialize(world_id, op_username, username)
    @world = World.find(world_id)
    @op = MinecraftPlayer.find_by_username(op_username)
    @player = MinecraftPlayer.find_or_create_by(username: username)
  end

  def perform?
    @world.player_opped? @op
  end
end
