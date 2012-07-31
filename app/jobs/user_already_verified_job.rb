class UserAlreadyVerifiedJob < Job
  @queue = :high

  def initialize(username, verification_token)
    @username = username
    @user = User.where(verification_token: verification_token).first
  end

  def perform!
    @user.private_channel.trigger! 'alreadyVerified', {username: @username}.to_json
  end

end
