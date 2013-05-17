class UserBonusesObserver < ActiveRecord::Observer
  observe :user

  def after_create(user)
    Bonuses::GettingStarted.give_to(user)
  end

  def after_save(user)
    if user.confirmed_at_changed?
      Bonuses::ConfirmedEmail.give_to(user)
    end
  end

end
