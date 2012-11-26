class CoinFairyJob < Job

  def perform!
    User.where(Bonuses::CoinFairy.eligable_user_query).find_each do |user|
      Bonuses::CoinFairy.claim!(user)
    end
  end

end
