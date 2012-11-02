class CreditFairyJob < Job

  def perform!
    User.low_credits.find_each do |user|
      user.gift_credits
      user.save
    end
  end

end
