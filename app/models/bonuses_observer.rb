class BonusesObserver < ActiveRecord::Observer
  observe :user

  def after_create(user)
    Bonuses::GettingStarted.claim!(user)

    if invitor = user.invited_by
      Bonuses::ReferredFriend.create(
        user: invitor,
        friend: user,
        state: Bonuses::ReferredFriend::States[:signed_up]
      )
      Bonuses::Referred.claim!(user)
    end
  end

  # update the referral state when the user goes through stages (confirmed, played, paid etc)
  def before_save(user)
    if user.confirmed_at_changed?
      if invitor = user.invited_by
        if invitation = invitor.bonuses.where(friend_id: user.id).first
          invitation.update_attribute :state, Bonuses::ReferredFriend::States[:confirmed_email]
        end
      end
    end
  end
end
