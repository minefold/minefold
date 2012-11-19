class CreditFairyJob < Job

  def perform!
    User.where(Bonuses::CreditFairy.eligable_user_query).find_each do |user|
      Bonuses::CreditFairy.claim!(user)
    end
  end

end
