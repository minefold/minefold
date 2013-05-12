class BonusesObserver < ActiveRecord::Observer
  observe :user

  # when a user signs up either:
  #  they weren't invited
  #  there is an existing invite sent via email
  #  they signed up using an invite link

  def after_create(user)
    Bonuses::GettingStarted.claim!(user)

    # is there an existing invite?
    if invite = Bonuses::ReferredFriend.where("data -> 'email' = ?", user.email).first
      invite.friend = user
      invite.signed_up!
      invite.save!

      user.update_attribute :invited_by_id, invite.user.id unless user.invited_by

    elsif invitor = user.invited_by
      # if not, and they signed up through an invite link, create one in the signed up state
      Bonuses::ReferredFriend.create(
        user: invitor,
        friend: user,
        state: Bonuses::ReferredFriend::States[:signed_up]
      )
    end
  end

  # update the referral state when the user goes through stages (confirmed, played, paid etc)
  def after_save(user)
    if user.confirmed_at_changed?
      Bonuses::ConfirmedEmail.claim!(user)

      if invitor = user.invited_by
        Bonuses::Referred.claim!(user)

        if invite = invitor.bonuses.where(friend_id: user.id).first
          invite.confirmed_email!
        end
      end
    end
  end
end
