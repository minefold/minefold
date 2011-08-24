class SaveChatMessage
  @queue = :high

  def self.perform(world_id, username, raw)
    world = World.find(world_id)
    user = User.find_by_username(username)
    Chat.create(user: user, wall: world, raw: raw)
  end
end
