class UserVerifiedJob < Job
  @queue = :low

  def initialize(user_id, player_id)
    @user = User.find(user_id)
    @player = MinecraftPlayer.find(player_id)
  end

  def perform!
    @player.user = @user
    @player.fetch_avatar
    @player.save

    @user.private_channel.trigger!('verified', @player.to_json)
  end

end
