class AvatarObserver < Mongoid::Observer
  observe :user
  
  def after_save user
    if user.safe_username_changed?
      puts "queue avatar fetch"
      Resque.enqueue FetchAvatarJob, user.id
    end
  end
end
