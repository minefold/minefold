class PlayerDisconnectedJob
  @queue = :high

  # TODO Pass in user_id rather than username
  # TODO Pass in world too
  def self.perform(username, connected_at)
    user = User.by_username(username).first
    world = user.current_world
    new.process!(user, world, connected_at)
  end
  
  def process!(user, world, connected_at)
    world.record_event! Disconnection, source: user,
                                created_at: connected_at

    # TODO Broadcast pusher event
  end

end
