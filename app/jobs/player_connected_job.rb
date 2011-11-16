class PlayerConnectedJob < TweetJob
  @queue = :high

  def self.perform username, connected_at
    if user = User.first(conditions: { username:username })
      user.played!
    end
    
    # %W(whatupdave chrislloyd).each do |dude|
    #   tweet dude, "#{username} just connected"
    # end
  end

end
