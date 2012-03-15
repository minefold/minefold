class PlayerOppedJob < Job
  @queue = :low

  def initialize(world_id, op_username, username)
    @world = World.find(world_id)
    @op = MinecraftPlayer.find()
    @player = MinecraftPlayer.find_or_create_by(username: username)
  end

  def perform!
    @world.opped_players.push(@player)
  end

end
