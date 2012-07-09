namespace :users do
  namespace :credits do
    desc "Reset users credits back to monthly free allowance"
    task :reset => :environment do
      monthly_credits = User::FREE_CREDITS
      users_to_reset = User.where(:credits.lt => monthly_credits).select{|u| Time.now >= (u.last_credit_reset || u.created_at) + 1.month }

      users_to_reset.each do |user|
        reset_due = (user.last_credit_reset || user.created_at) + 1.month
        puts "#{user.id}  signed up: #{user.created_at.strftime('%d %b %Y')}  reset due: #{reset_due.strftime('%d %b %Y')}  #{(user.username || '').ljust(18)} #{'PRO' if user.pro?} credits #{user.credits} => #{monthly_credits}"
        user.credits = monthly_credits
        user.last_credit_reset = reset_due

        user.save

        if user.notify?(:credits_reset) and !user.pro?
          UserMailer.credit_reset(user.id).deliver
          Mixpanel.track 'sent reset credit email', distinct_id: user.mpid.to_s, mp_name_tag: user.email
        end

        Mixpanel.track 'reset credits', distinct_id: user.mpid.to_s, mp_name_tag: user.email
      end
      puts "reset #{users_to_reset.size} users"
    end
  end
end