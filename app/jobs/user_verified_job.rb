class UserVerifiedJob < Job
  @queue = :high

  def initialize(verification_code, username)
    @user = User.find_by(verification_code: verification_code)
    @player = MinecraftPlayer.find_by_username(username)
  end

  def perform!
    @player.user = @user
    @player.fetch_avatar
    @player.save

    @user.unset :verification_code

    @user.private_channel.trigger!('verified', @player.to_json)

    if @player.playing?
      @player.tell 'Your account has been verified'
    end
  end

end
