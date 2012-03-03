class PlayerDisconnectedJob
  @queue = :high

  # TODO Pass in user_id rather than username
  # TODO Pass in world too
  def self.perform(username, disconnected_at)
    user = User.by_username(username).first
    world = user.current_world
    new.process!(user, world, disconnected_at) if world
  end

  def process!(user, world, disconnected_at)
    Events::Disconnection.create source: user,
                                 target: world,
                                 created_at: disconnected_at

    # TODO Broadcast pusher event
  end

end
