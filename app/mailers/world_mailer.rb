class WorldMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'Minefold <team@minefold.com>'
  
  def play_request(world_id, player_id)
    @world    = World.find(world_id)
    @creator  = @world.creator
    @player   = User.find(player_id)

    mail   to: @creator.email,
      subject: "#{@player.username} would like to play in #{@world.name}"
  end

  def player_added(world_id, player_id)
    @world   = World.find(world_id)
    @player  = User.find(player_id)
    
    @creator = @world.creator

    mail   to: @player.email,
      subject: "#{@creator.username} has added you #{@world.name}"
  end
  
  def world_started world_id, player_id
    @player = User.find player_id
    @world  = World.find world_id
  
    @online_players  = @world.current_players
    @recent_activity = @world.events.limit(5)
  
    mail     to: @player.email,
        subject: "Your friends are playing on Minefold in #{@world.name}"
  end
end
