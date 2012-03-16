class PlayerDeoppedJob < OpActionJob
  @queue = :low

  def perform!
    @world.deop_player! @player
  end

end
