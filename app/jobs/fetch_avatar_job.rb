class FetchAvatarJob
  @queue = :low

  def self.perform(minecraft_account_id)
    job = new(minecraft_account_id)

    puts "Fetching avatar for #{minecraft_account.safe_username}"
    job.process!
    puts "Fetched avatar for #{minecraft_account.safe_username}"
  end

  def initialize(minecraft_account_id)
    @minecraft_account = MinecraftAccount.find(minecraft_account_id)
  end

  def process!
    minecraft_account.fetch_avatar
    minecraft_account.save
  end

end
