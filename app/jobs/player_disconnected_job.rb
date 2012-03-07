class PlayerDisconnectedJob
  @queue = :high

  # TODO deploy new prism then change these names
  def self.perform(user_id_or_username, world_id_or_disconnected_at, connected_at = nil, disconnected_at = nil)
    user_id = BSON::ObjectId(user_id_or_username.to_s) rescue nil
    user = user_id ? User.find(user_id) : User.by_username(user_id_or_username).first

    world_id = BSON::ObjectId(world_id_or_disconnected_at.to_s) rescue nil
    world = world_id ? World.find(world_id) : user.current_world

    if world
      if disconnected_at
        new.process!(user, world, connected_at, disconnected_at)
      else
        new.process!(user, world, nil, world_id_or_disconnected_at)
      end
    end
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
