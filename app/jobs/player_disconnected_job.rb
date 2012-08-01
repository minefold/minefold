class PlayerDisconnectedJob < Job
  @queue = :high

  def initialize(player_id, world_id, connected_at, disconnected_at)
    @player = MinecraftPlayer.find(player_id)
    @world = World.unscoped.where(_id: world_id).first
    @connected_at, @disconnected_at = Time.parse(connected_at), Time.parse(disconnected_at)
  end

  def perform!
    if @connected_at
      seconds = @disconnected_at - @connected_at

      if user = @player.user
        Mixpanel.track 'played',
          distinct_id: user.id,
          seconds: seconds,
          minutes: (seconds / 60.0).to_i,
          hours: (seconds / 60.0 / 60.0).to_i,
          pro: user.pro?
      end
    end
  end

end
