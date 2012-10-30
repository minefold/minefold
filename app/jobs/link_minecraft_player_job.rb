class LinkMinecraftPlayerJob < Job
  @queue = :high

  def initialize(auth_token, username)
    @user = User.find_by_authentication_token(auth_token)
    @player = Player.minecraft.find_by_uid(username)
  end

  def perform!
  end

end
