class Bonus

  class_attribute :credits
  self.credits = 0

  class_attribute :claim_limit
  self.claim_limit = 1

  def self.credit_limit
    self.claim_limit * self.credits
  end

  def self.claim!(user)
    if claimable_by?(user)
      user.increment_credits!(credits)
      track_claim!(user)
    end
  end

# private

  def self.track_claim!(user)
    BonusClaim.create!(user: user, bonus_type: self.name, credits: credits)

    Mixpanel.async_track 'bonus claimed', distinct_id: user.distinct_id,
                                          bonus:       self.name,
                                          credits:     self.credits,
                                          time:        Time.now.to_i

    Mixpanel.async_person_add(user.distinct_id, credits: self.credits)
  end

  def self.claims
    BonusClaim.where(bonus_type: self.name)
  end

  def self.claimable_by?(user)
    claims.where(user_id: user.id).count < self.claim_limit
  end

end
