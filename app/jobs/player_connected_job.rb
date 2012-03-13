class PlayerConnectedJob
  @queue = :high

  # TODO Pass in user_id rather than username
  # TODO Pass in world too
  def self.perform(username, connected_at)
    user = User.by_username(username).first
    world = user.current_world
    return unless world

    new.process!(user, world, connected_at)
  end

  def process!(user, world, connected_at)
    world.last_played_at = connected_at
    world.save

    membership = world.memberships.where(user_id: user.id).first
    membership.last_played_at = connected_at if membership


    Events::Connection.create! source: user,
                               target: world,
                               created_at: connected_at
  end

end
