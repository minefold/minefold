# Triggered from in the game:
#
#   /invite dave@minefold.com check oot mah shiny thing!
#
# (message is optional)
class InviteJob < Job
  @queue = :low

  def initialize(user_id, world_id, address)
    @user_id, @world_id = user_id, world_id
    @address = address
  end

  # TODO Support other invite types like Twitter and Facebook
  def perform!(user_id, world_id, invitee)
    if address =~ /([^@]+@\S+)\s*(.*)$/
      email, message = $1, $2
      UserMailer.invite(user_id, world_id, email, message).deliver
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
