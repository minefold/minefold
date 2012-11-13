class BonusesObserver < ActiveRecord::Observer
  observe :user

  def after_create(user)
    Bonuses::GettingStarted.claim!(user)

    if user.invited_by
      Bonuses::ReferredFriend.claim!(user.invited_by)
      Bonuses::Referred.claim!(user)
    end
  end

end
