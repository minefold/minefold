namespace :subscription do
  task :cancel_all do
    User.where('customer_id is not null').each do |user|
      puts "#{user.username} #{user.email} #{user.customer_id} CANCEL"
      c = Stripe::Customer.retrieve(user.customer_id)
      c.cancel_subscription(at_period_end: true) rescue nil
    end
  end
end