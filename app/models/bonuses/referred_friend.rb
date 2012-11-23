class Bonuses::ReferredFriend < Bonus
  self.credits = 500

  LIMIT = 16

  def self.credit_limit
    credits * LIMIT
  end

  def claimable?
    self.class.where(user_id: user.id).count < LIMIT
  end

end
