class FetchAvatarJob < Job
  @queue = :low

  def initialize(player_id)
    @player = MinecraftPlayer.find(player_id)
  end
  
  def process!
    @player.fetch_avatar
    @player.save
  rescue OpenURI::HTTPError
    puts "no skin for #{@player.username}"
  end
end
