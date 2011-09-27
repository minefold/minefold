class TweetJob

  def self.tweet user, message
    if Rails.env.production?
      Twitter.direct_message_create user, message
    else
      Rails.logger.info "[Twitter DM] #{user} #{message}"
    end

  rescue Twitter::Forbidden # Duplicate tweet error
  end

end
