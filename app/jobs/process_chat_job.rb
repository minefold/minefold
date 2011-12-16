class ProcessChatJob
  @queue = :high

  def self.perform(world_id, username, text)
    world, user = World.find(world_id), User.by_username(username).first
    
    new.process!(world, user, text)
  end

  def process!(world, user, text)
    world.record_event! Chat, source: user,
                              text: text
  end
  
end
