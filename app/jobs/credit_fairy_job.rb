class CreditFairyJob < Job

  def perform!
    User.needs_magic_fairy_dust.find_each do |user|
      user.gift_credits
      user.save
    end
  end

end
