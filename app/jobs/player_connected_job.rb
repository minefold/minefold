class PlayerConnectedJob < TweetJob
  @queue = :high

  def self.perform username, connected_at
    %W(whatupdave chrislloyd).each do |dude|
      tweet dude, "#{username} just connected"
    end
  end

end
