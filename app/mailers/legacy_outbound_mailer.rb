class LegacyOutboundMailer < ActionMailer::Base
  include Resque::Mailer

  def invite(player_id, world_id, invitee_email, message = nil)
    @player = MinecraftPlayer.find(player_id)
    @world = World.find world_id
    @message = message

    # track(@player.user, 'sent invite email') if @player.user

    mail to: invitee_email,
         subject: "#{@player.username} wants you to play Minecraft in #{@world.name}"
  end

  def claim_account_info(player_id, email, message = nil)
    @player = MinecraftPlayer.find(player_id)

    # track(@player, 'sent claim email')
    mail to: email,
         subject: "Claim #{@player.username} on Minefold"
  end

  # class Preview < ::MailView
  #   def invite
  #     user = User.chris
  #     player = user.player
  #     world = World.find_by(name: 'minebnb', creator_id: user.id)
  #
  #     UserMailer.world_started(player.id, world.id, 'dave@minefold.com', 'hey sup!')
  #   end
  # end

  # private
  #
  #   def track(user, event)
  #     Mixpanel.track(event, distinct_id: user.distinct_id.to_s)
  #   end

end
