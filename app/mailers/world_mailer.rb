class WorldMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'team@minefold.com'

  def play_request(world_id, player_id)
    @world    = World.find(world_id)
    @creator  = @world.creator
    @player   = User.find(player_id)

    mail   to: @creator.email,
      subject: "#{@player.username} would like to play in #{@world.name}"
  end

  def player_added(world_id, player_id)
    @world   = World.find(world_id)
    @creator = @world.creator
    @player  = User.find(player_id)

    mail   to: @player.email,
      subject: "#{@creator.username} has let you play in #{@world.name}"
  end
  
  def self.deliver_to_all!(world, ignore)
    world.players
  end
  
  def world_started world_id, player_id
    @world  = World.find world_id
    @player = User.find player_id
    
    @online_players  = @world.current_players
    @recent_activity = @world.wall_items.last(5)
    
    mail     to: @player.email,
        subject: "Your friends are playing on Minefold in #{@world.name}"
  end
end
