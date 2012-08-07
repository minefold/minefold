class UserAlreadyVerifiedJob < Job
  @queue = :high

  def initialize(username, verification_token)
    @username = username
    @user = User.where(verification_token: verification_token).first

    # Weird case where the user doesn't have a verification token
    # TODO This is a quick fix but need to investigate the root cause.
    if !@user && player = MinecraftPlayer.by_username(@username).first
      @user = player.user
    end
  end

  def perform!
    @user.private_channel.trigger! 'alreadyVerified', {username: @username}.to_json
  end

end
