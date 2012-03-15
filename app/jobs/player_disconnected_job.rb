class PlayerDisconnectedJob < Job
  @queue = :high

  def initialize(player_id, world_id, timestamp)
    @player = MinecraftPlayer.find(player_id)
    @world = World.find(world_id)
    @timestamp = timestamp
  end

  def perform!
    Events::Disconnection.create source: @user,
                                 target: @world,
                                 created_at: @timestamp

    if connected_at
      seconds = disconnected_at - connected_at
      Mixpanel.track 'played',
        seconds: seconds,
        minutes: (seconds / 60.0).to_i,
        hours: (seconds / 60.0 / 60.0).to_i,
        distinct_id: user.mpid.to_s,
        mp_name_tag: user.email
    end
  end

end
