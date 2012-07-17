class PlayerAddedToBlacklistJob < OpActionJob
  @queue = :high

  def perform!
    unless @world.creator.minecraft_player == @player
      @world.blacklist_player! @player
    end
  end
end
