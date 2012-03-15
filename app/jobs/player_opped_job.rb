class PlayerOppedJob < OpActionJob
  @queue = :low

  def perform!
    @world.add_to_set :opped_player_ids, @player.id
  end

end
