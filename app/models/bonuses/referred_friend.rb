class Bonuses::ReferredFriend < Bonus
  self.coins = 600

  LIMIT = 16

  def self.coin_limit
    coins * LIMIT
  end

  def claimable?
    self.class.where(user_id: user.id).count < LIMIT
  end

end
