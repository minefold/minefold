class WorldStartedJob
  @queue = :low

  def self.perform world_id
    world   = World.find(world_id)
    online_players  = world.current_players
    offline_players = User.find(world.whitelisted_player_ids - world.current_player_ids)
    
    puts "world started:#{world.name}  whitelisted:#{world.whitelisted_player_ids.size}  online: #{online_players.size}  offline: #{offline_players.size}"
    
    if online_players.any?
      offline_players.each do |offline_player|
        puts "email: #{offline_player.username} #{offline_player.email}"
        WorldMailer.world_started(world.id, offline_player.id).deliver!
      end
    end
  end
end