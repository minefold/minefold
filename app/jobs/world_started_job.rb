class WorldStartedJob
  include Resque::Logging
  
  @queue = :low

  def self.perform world_id
    world   = World.find(world_id)
    online_players  = world.players
    offline_players = world.offline_players
    
    logger.info "world started:#{world.name}  whitelisted:#{world.memberships.size}  online: #{online_players.size}  offline: #{offline_players.size}"
    
    if online_players.any?
      offline_players.each do |offline_player|
        if throttled?(offline_player)
          logger.info "throttled: #{offline_player.email}  last: #{offline_player.last_world_started_mail_sent_at}"
        else
          logger.info "sending: #{offline_player.email}  last: #{offline_player.last_world_started_mail_sent_at}"
          WorldMailer.world_started(world.id, offline_player.id).deliver
          offline_player.last_world_started_mail_sent_at = Time.now
          offline_player.save
        end
      end
    end
  end
  
  def self.throttled? user
    if user.last_world_started_mail_sent_at
      (Time.now - user.last_world_started_mail_sent_at) < 24.hours
    else
      false
    end
  end
end