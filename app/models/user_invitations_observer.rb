class UserInvitationsObserver < ActiveRecord::Observer
  observe :user

  # Create an invitation if the user signed up via. an invite page or else try and credit people who have sent invitations to that person.
  def after_create(user)
    if user.invited_by_id?
      invitation = Invitation.new(sender: user.invited_by, friend: user)
      invitation.accept!
    else
      # TODO There's a potential exploit here where someone creates 100 dummy accounts, invites one account and collects all the free time on that one account.
      Invitation.where(email: user.email).each do |invitation|
        invitation.friend = user
        invitation.accept!
      end
    end
  end

  # Mark all invites for that user as confirmed
  def after_save(user)
    if user.confirmed_at_changed?
      Invitation.where(friend_id: user.id).each do |invitation|
        invitation.confirm!
      end
    end
  end

end
