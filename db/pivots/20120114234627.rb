# Cleans whitelisted_world_ids and failed_payments from Users

User.all.each do |u|
  u.unset :whitelisted_world_ids
  u.unset :failed_payments
end
