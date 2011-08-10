User.all.each do |user|
  if user.minutes_played > 0
    user.last_played_at = user.last_sign_in_at
    user.save

    user.invite.claimed = true
    user.invite.save
  end
end



class Verify
  def self.perform(username, time)
    user = User.find_by_username(username)
    user.last_played_at = time
    user.save

    # User and username is new to the system
    if user.invite.unclaimed?
      # Credits user and invite.creator
      # also sets invite.claimed = true
      user.claim_invite!
    end

  end
end
