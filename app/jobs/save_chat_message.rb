class SaveChatMessage
  @queue = :high

  def self.perform(world_id, username, raw)
    world = World.find(world_id)
    user = User.find_by_username(username)

    world.push :wall_items, Chat.new(user: user, raw: raw)
  end
end