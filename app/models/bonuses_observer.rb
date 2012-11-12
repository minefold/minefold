class BonusesObserver < ActiveRecord::Observer
  observe :user

  def after_create(user)
    Bonuses::GettingStarted.claim!(user)
  end

end
