class PlayerConnectedJob < Job
  @queue = :high

  def initialize(player_id, world_id, timestamp)
    @player = MinecraftPlayer.find(player_id)
    @world = World.unscoped.where(_id: world_id).first
    @time = Time.parse(timestamp)
  end

  def perform!
    @world.set :last_played_at, @time
  end
end
