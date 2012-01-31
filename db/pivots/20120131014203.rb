# Update users who have played to a bogus last_played_at.

User.all.each do |u|
  if u.minutes_played > 0
    u.last_played_at = Time.now
    u.save
  end
end
