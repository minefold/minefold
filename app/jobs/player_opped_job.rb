class PlayerOppedJob
  @queue = :low

  def self.perform(world_id, player_username)
    world = World.find(world_id)
    user = User.by_username(player_username).first

    new.process! world, user
  end

  def process!(world, user)
    membership = world.memberships.find_or_initialize_by(user_id: user.id)
    membership.role = Membership::OP
    world.save
  end
end
