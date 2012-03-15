class PlayerRemovedFromWhitelistJob < Job
  @queue = :high

  def initialize(world_id, username)
    @world = World.find(world_id)
    @player = MinecraftPlayer.find_or_create_by(username: username)
  end

  def perform!
    @world.whitelisted_players.pull(@player)
  end

end
