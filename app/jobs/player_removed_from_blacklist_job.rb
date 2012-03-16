class PlayerRemovedFromBlacklistJob < OpActionJob
  @queue = :high

  def perform!
    @world.blacklisted_players.pull(@player)
  end

end
