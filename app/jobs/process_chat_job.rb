class ProcessChatJob < Job
  @queue = :high

  def initialize(world_id, username, text)
    @world = World.unscoped.where(_id: world_id).first
    @player = MinecraftPlayer.find_or_create_by(username: username)
    @text = text
  end

  def perform!
    Events::Chat.create! source: @player,
                         target: @world,
                         text: @text
  end

end
