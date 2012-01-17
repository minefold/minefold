# Confirms all user's emails

now = Time.now
User
  .where(:confirmed_at.exists => false)
  .update_all(confirmed_at: now)
