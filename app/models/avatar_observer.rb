class AvatarObserver < Mongoid::Observer
  observe :user
  
  def after_save user
    if user.safe_username_changed?
      Resque.enqueue FetchAvatarJob, user.id
    end
  end
end
