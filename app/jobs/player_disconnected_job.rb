class PlayerDisconnectedJob < Job
  @queue = :high

  def initialize(player_id, world_id, connected_at, disconnected_at)
    @player = MinecraftPlayer.find(player_id)
    @world = World.unscoped.find(world_id)
    @connected_at, @disconnected_at = Time.parse(connected_at), Time.parse(disconnected_at)
  end

  def perform!
    Events::Disconnection.create source: @user,
                                 target: @world,
                                 created_at: @disconnected_at

    if @connected_at
      seconds = @disconnected_at - @connected_at
      Mixpanel.track 'played',
        seconds: seconds,
        minutes: (seconds / 60.0).to_i,
        hours: (seconds / 60.0 / 60.0).to_i,
          distinct_id: @player.distinct_id,
          mp_name_tag: @player.friendly_id
    end
  end

end
