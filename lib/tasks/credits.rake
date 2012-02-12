namespace :users do
  namespace :credits do
    desc "Reset users credits back to monthly free allowance"
    task :reset => :environment do
      include Mixpanel
      
      monthly_credits = (User::FREE_HOURS.hours / User::BILLING_PERIOD)
      users_to_reset = User.where(:credits.lt => monthly_credits).select{|u| Time.now > (u.last_credit_reset || u.created_at) + 1.month }
      
      users_to_reset.each do |user|
        reset_due = (user.last_credit_reset || user.created_at) + 1.month
        puts "#{user.id}  signed up: #{user.created_at.strftime('%d %b %Y')}  reset due: #{reset_due.strftime('%d %b %Y')}  #{user.username.ljust(18)} #{'PRO' if user.pro?} credits #{user.credits} => #{monthly_credits}"
        user.credits = monthly_credits
        
        track 'reset credits', distinct_id: user.id.to_s, mp_name_tag: user.safe_username
        user.save
        
        UserMailer.credits_reset(user.id).deliver unless user.pro?
      end
      puts "reset #{users_to_reset.size} users"
    end
  end
end