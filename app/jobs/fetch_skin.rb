class FetchSkin
  @queue = :low

  def self.perform user_id
    new.process! User.find(user_id)
  end

private

  def process!
    user.fetch_skin!
    user.save
  rescue OpenURI::HTTPError
    Rails.logger.info "No skin for #{user.username}"
  end

end
