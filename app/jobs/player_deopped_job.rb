class PlayerDeoppedJob < OpActionJob
  @queue = :low

  def perform!
    @world.opped_players.pull(@player)
  end

end
