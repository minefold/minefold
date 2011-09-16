class PlayerConnectedJob
  @queue = :high

  def self.perform username, connected_at
    
    %W(whatupdave chrislloyd).each do |dude|
      send_dm dude, "#{username} just connected"
    end
    
  end
  
  def self.send_dm user, message
    if Rails.env.production?
      Twitter.direct_message_create user, message
    else
      Rails.logger.info "[Twitter DM] #{user} #{message}"
    end
  end
end
