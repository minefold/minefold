class DownloadAvatarJob
  @queue = :low

  def self.perform user_id
    user = User.find(user_id)
    user.remote_avatar_url = "http://s3.amazonaws.com/MinecraftSkins/#{user.safe_username}.png"
    user.save
  end
end
