class PlayerRemovedFromWhitelistJob < OpActionJob
  @queue = :high

  def perform!
    @world.whitelisted_players.pull(@player)
  end
end
