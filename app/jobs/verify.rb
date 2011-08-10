## Migration

# User.all.each do |user|
#   if user.minutes_played > 0
#     user.last_played_at = user.last_sign_in_at
#     user.save
#
#     user.invite.claimed = true
#     user.invite.save
#   end
# end

class Verify
  @queue = :low

  def self.perform(username, time)
    user = User.find_by_username(username)
    user.last_played_at = time
    user.save

    user.verify! if user.invite.unclaimed?
  end
end
