class MinutePlayedJob
  @queue = :high

  def self.perform(user_id, world_id, timestamp)
    user = User.find(user_id)
    world = World.unscoped.find(world_id)

    new.process!(user, world, timestamp)
  end

  def process!(user, world, timestamp)
    user.inc :minutes_played, 1
    world.inc :minutes_played, 1

    membership = world.memberships.where(user_id: user.id).first
    membership.inc :minutes_played, 1 if membership
  end
end
