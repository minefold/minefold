class UserVerifiedJob < Job
  @queue = :high

  def initialize(username, verification_token)
    @user = User.where(verification_token: verification_token).first
    @player = MinecraftPlayer.find_by_username(username)
  end

  def tell_player message
    @player.tell "[MINEFOLD] #{message}" if @player.online?
  end

  def perform!
    if @user.nil?
      tell_player 'Sorry! That verification code is incorrect'

    else
      @player.user = @user
      @player.fetch_avatar
      @player.save

      # @user.unset :verification_token

      @user.private_channel.trigger!('verified', @player.to_json)

      tell_player 'Welcome! Your account is now verified'
    end
  end

end
