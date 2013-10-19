namespace :stripe do
  namespace :subscriptions do
    task :cancel_all do
      User.where('customer_id is not null').each do |user|
        puts "#{user.username} #{user.email} #{user.customer_id} CANCEL"
        c = Stripe::Customer.retrieve(user.customer_id)
        c.cancel_subscription(at_period_end: true) rescue nil
      end
    end
  end

  namespace :invoices do
    task :close_all do
      offset = 0
      count = 100
      i = 0

      begin
        invoices = Stripe::Invoice.all(offset: offset, count: count).to_a
        puts "Fetched #{invoices.size} > ##{offset}"

        invoices.each do |invoice|
          i += 1

          unless invoice.closed
            puts "#{i} invoice #{invoice.id} CLOSE"
            invoice.closed = true
            invoice.save
          end
        end
        offset += invoices.size

      end until invoices.size < count
    end
  end
end