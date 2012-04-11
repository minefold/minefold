class PlayerRemovedFromWhitelistJob < OpActionJob
  @queue = :high

  def perform!
    @world.unwhitelist_player! @player
    $redis.publish("worlds:#{@world.id}:whitelist_change:#{@player.id}", "removed")
    @op.tell "[MINEFOLD] #{@player.username} removed from whitelist" if @op.online?
  end
end
