class ServerTickedJob < Job
  @queue = :high

  def initialize(id, timestamp, state)
    @server = Server.find_by_party_cloud_id(id)
    @timestamp = timestamp
    @state = state
  end

  def perform!
    # TODO Increment stats!
    
    if @server.super?
      players = state['players']
        .map {|uid| Player.minecraft.find_by_uid(uid) }
      
      users = players.map {|player| player.user }
      
      # Kick users who've gone over their time
      users.each {|user| user.kick! unless user.credits_available? }
      
      # Deduct credits from players on Super Servers
      users.each {|user| user.tick! }
    end
  end

end
