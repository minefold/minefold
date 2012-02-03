# Describe pivot
User.all.each do |user|
  
  user.ensure_authentication_token!
  
end
