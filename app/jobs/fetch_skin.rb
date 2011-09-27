class FetchSkin
  @queue = :low

  def self.perform user_id
    user = User.find(user_id)
    user.fetch_skin!
    user.save
  rescue OpenURI::HTTPError
    Rails.logger.info "No skin for #{user.username}"
  end
end
