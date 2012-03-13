class InviteJob

  # this comes from the game eg:
  # /invite dave@minefold.com check oot mah shiny thing!
  # the message is optional
  def self.perform world_id, username, invitee
    # todo: support other invite types like twitter and facebook
    user = User.by_username(username).first
    
    if invitee =~ /([^@]+@\S+)\s*(.*)$/
      email, message = $1, $2
      UserMailer.invite(user.id, world_id, email, message).deliver
    end
  end

  def self.tweet user, message
    if Rails.env.production?
      Twitter.direct_message_create user, message
    else
      Rails.logger.info "[Twitter DM] #{user} #{message}"
    end

  rescue Twitter::Forbidden # Duplicate tweet error
  end

end
