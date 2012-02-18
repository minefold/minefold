class ProcessChatJob
  @queue = :high

  def self.perform(world_id, username, text)
    world, user = World.find(world_id), User.by_username(username).first

    new.process!(world, user, text)
  end

  def process!(world, user, text)
    caht = Events::Chat.create! source: user, target: world, text: text

    world.broadcast "#{chat.pusher_key}-created", chat.attributes
  end

end
