class PlayerOppedJob < OpActionJob
  @queue = :low

  def perform!
    @world.op_player! @player
  end
end
