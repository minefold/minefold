class SaveChatMessage
  @queue = :high

  def self.perform(world_id, username, raw)
    world = World.find(world_id)
    user = User.first conditions:{username:username}

    world.wall_items.push Chat.new(user: user, raw: raw)
  end
end