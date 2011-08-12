class SaveChatMessage
  @queue = :high
  
  def self.perform world_id, username, body
    world = World.find world_id
    user = User.find_by_username username
    Chat.create(user: user, wall: world, raw: body)
  end
end
