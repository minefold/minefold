class PlayerAddedToBlacklistJob < OpActionJob
  @queue = :high

  def perform!
    @world.add_to_set :blacklisted_player_ids, @player.id
  end
end
