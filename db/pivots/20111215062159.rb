# Force set referral code for existing users

# Downcase existing referral codes
users = User.where(:referral_code.exists => true)

log "downcasing #{users.count} referral codes"

users.each do |user|
  user.set :referral_code, user.referral_code.downcase
end

# Create a referral code for users who don't have one
users = User.where(:referral_code.exists => false)

log "setting #{users.count} referral codes"

users.each do |user|
  user.set :referral_code, User.free_referral_code
end
