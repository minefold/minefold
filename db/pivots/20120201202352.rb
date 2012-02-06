# Gives paid users 12 months of Pro

paid_users = (
  Stripe::Customer.all(count: 100).data.
      map{|c| c['description'] }.map{|d| id, username = d.split('-'); { id: id, username: username } } +
  Stripe::Charge.all(:count => 100).data.
      map{|c| c['description'] }.compact.select{|c| c.include? '-' }.map{|d| d.split('-').last }.map{|d| {id: d.split(':').first} }
)

paid_users.map do |u|
  user = u[:id].empty? ? User.by_username(u[:username]).first : User.where(_id: u[:id]).first
  puts "No user found for #{u}" unless user
  user
end.compact.uniq_by{|u| u.id }.sort_by{|u| u.username}.each do |user|
  user.credits = 0 if user.credits < 0
  user.plan_expires_at = Time.now + 12.months
  user.save!
  puts "#{user.username} plan expires: #{user.plan_expires_at}"

  CampaignList.paid_users.subscribe user
end
