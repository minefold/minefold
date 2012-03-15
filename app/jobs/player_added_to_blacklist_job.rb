class PlayerAddedToBlacklistJob < Job
  @queue = :high

  def initialize(world_id, username)
    @world = World.find(world_id)
    @player = MinecraftPlayer.by_username(username).first
  end

  def perform!
    @world.blacklisted_players.push(@player)
  end

end
