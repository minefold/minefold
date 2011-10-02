class FetchAvatar
  @queue = :low

  def self.perform user_id
    new.process User.find(user_id)
  end

  def process(user)
    user.fetch_avatar!
    user.save
    puts "downloaded skin for #{user.safe_username}"
  rescue OpenURI::HTTPError
    puts "no skin for #{user.safe_username}"
  end

end
