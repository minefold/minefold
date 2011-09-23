class SaveChatMessage
  @queue = :high

  def self.perform(world_id, username, raw)
    world = World.find(world_id)
    user = User.first conditions:{username:username}

    chat = Chat.new(user: user, raw: raw)

    world.wall_items.push chat

    world.broadcast 'chat-create', to_json(include: :user)
  end
end