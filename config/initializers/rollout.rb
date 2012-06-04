$rollout = Rollout.new($redis)

$rollout.define_group :beta_testers do |user|
  user.admin?
end

$rollout.activate_group(:funpack_settings, :beta_testers)
