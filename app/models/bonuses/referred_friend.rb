class Bonuses::ReferredFriend < Bonus
  self.credits = 500

  def claimable?
    user.bonuses.where(type: self.class).count < 16
  end

end
