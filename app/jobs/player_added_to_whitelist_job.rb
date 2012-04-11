class PlayerAddedToWhitelistJob < OpActionJob
  @queue = :high

  def perform!
    @world.whitelist_player! @player
    # @op.tell "[MINEFOLD] #{@player.username} added to whitelist" if @op.online?
    # $redis.publish("worlds:#{@world.id}:whitelist_change:#{@player.id}", "added")
  end
end
