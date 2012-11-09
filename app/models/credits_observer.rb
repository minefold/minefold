class CreditsObserver < ActiveRecord::Observer
  observe :user

  def before_create(user)
    user.credits = User::FREE_CREDITS
  end

end
