class OpActionJob < Job
  def initialize(world_id, op_username, username)
    @world = World.find(world_id)
    @op = MinecraftPlayer.find_by_username(op_username)
    @player = MinecraftPlayer.find_by_username(username)
  end

  def perform?
    @world.opped_players.include?(@op)
  end
end
