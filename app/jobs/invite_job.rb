# Triggered from in the game:
#
#   /invite dave@minefold.com check oot mah shiny thing!
#
# (message is optional)
class InviteJob < Job
  @queue = :low

  def initialize(world_id, username, address)
    @world_id = world_id
    @player = MinecraftPlayer.find_by_username(username)
    @address = address
  end
  
  # TODO Support other invite types like Twitter and Facebook
  def perform!
    if @address =~ /([^@]+@\S+)\s*(.*)$/
      email, message = $1, $2
      OutboundMailer.invite(@player.id, @world_id, email, message).deliver
    end
  end

  # def tweet(user, message)
  #   if Rails.env.production?
  #     Twitter.direct_message_create(user, message)
  #   else
  #     logger.info "[Twitter DM] #{user} #{message}"
  #   end
  #
  # # Duplicate tweet error
  # rescue Twitter::Forbidden
  # end

end
