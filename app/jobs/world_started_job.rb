class WorldStartedJob < Job
  @queue = :low

  def initialize(world_id)
    @world = World.find(world_id)
  end

  def perform?
    @world.players.any?
  end

  def perform!
    world.offline_players.each do |offline_player|
      unless throttled?(offline_player)
        WorldMailer.world_started(world.id, offline_player.id).deliver
      end
    end
  end

  def throttled?(user)
    if user.last_world_started_mail_sent_at?
      (Time.now - user.last_world_started_mail_sent_at) < 24.hours
    else
      false
    end
  end
end