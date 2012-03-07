require 'time'

class PlayerDisconnectedJob
  @queue = :high

  def self.perform(user_id, world_id, connected_at, disconnected_at)
    user = User.find(user_id)
    world = World.find(world_id)

    new.process!(user, world, Time.parse(connected_at), Time.parse(disconnected_at))
  end

  def process!(user, world, connected_at, disconnected_at)
    Events::Disconnection.create source: user,
                                 target: world,
                                 created_at: disconnected_at

    if connected_at
      seconds = disconnected_at - connected_at
      Mixpanel.track 'played',
        seconds: seconds,
        minutes: (seconds / 60.0).to_i,
        hours: (seconds / 60.0 / 60.0).to_i,
        distinct_id: user.mpid.to_s,
        mp_name_tag: user.email
    end

    # TODO Broadcast pusher event
  end

end
