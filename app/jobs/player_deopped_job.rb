class PlayerDeoppedJob < Job
  @queue = :low

  def initialize(world_id, username)
    @world = World.find(world_id)
    @player = MinecraftPlayer.find_or_create_by(username: username)
  end

  def perform!
    @world.opped_players.pull(@player)
  end

end
