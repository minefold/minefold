class PlayerAddedToWhitelistJob < OpActionJob
  @queue = :high

  def perform!
    @world.whitelist_player! @player
  end
end
