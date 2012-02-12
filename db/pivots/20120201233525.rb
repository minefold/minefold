# Generate authentication token for all users

User.all.each do |user|
  user.ensure_authentication_token!
end
