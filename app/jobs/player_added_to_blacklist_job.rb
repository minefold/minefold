class PlayerAddedToBlacklistJob < OpActionJob
  @queue = :high

  def perform!
    @world.blacklist_player! @player
  end
end
