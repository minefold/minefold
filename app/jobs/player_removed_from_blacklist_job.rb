class PlayerRemovedFromBlacklistJob < OpActionJob
  @queue = :high

  def perform!
    @world.pardon_player! @player
  end

end
