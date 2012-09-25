class CreditsObserver < ActiveRecord::Observer
  observe :user
  
  def before_create(user)
    user.credits = 600
  end
  
end
