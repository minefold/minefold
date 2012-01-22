class PlayerOppedJob
  @queue = :low

  def self.perform world_id, username
    user = User.by_username(username).first
    process! World.find(world_id), user if user
  end
  
  def process! world, user
    membership = world.memberships.where(user_id: user.id).first
    membership.op!
  end
end
