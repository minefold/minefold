class PlayerRemovedFromWhitelistJob < OpActionJob
  @queue = :high

  def perform!
    @world.unwhitelist_player! @player
  end
end
