class PlayerOppedJob
  @queue = :low

  def self.perform(world_id, player_username)
    world = World.unscoped.find(world_id)
    user = User.by_username(player_username).first

    return unless user and world

    new.process! world, user
  end

  def process!(world, user)
    membership = world.memberships.where(user_id: user.id).first
    if membership
      membership.op! 

      world.save
    end
  end
end
