class AvatarObserver < Mongoid::Observer
  observe :minecraft_player

  def after_save(account)
    if account.username_changed?
      Resque.enqueue(FetchAvatarJob, account.id)
    end
  end
end
