class PlayerAddedToWhitelistJob < OpActionJob
  @queue = :high

  def perform!
    @world.add_to_set :whitelisted_player_ids, @player.id
  end
end
