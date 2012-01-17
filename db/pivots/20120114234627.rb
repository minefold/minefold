# Cleans up users

User.all.each do |u|
  u.unset :whitelisted_world_ids
  u.unset :failed_payments
end
