class Bonus

  def self.credits(n = nil)
    @credits ||= n
  end

  def self.claim_limit(n = nil)
    @credits ||= n || 1
  end

  def self.claim!(user)
    if claims_left?(user)
      user.increment_credits!(credits)
      track_claim!(user)
    end
  end

# private

  def self.track_claim!(user)
    BonusClaim.create!(user: user, bonus_type: self.name, credits: credits)

    # TODO Uncomment
    # Mixpanel.track_async 'bonus claimed', distinct_id: user.distinct_id,
    #                                       bonus:       bonus.name,
    #                                       count:       bonus.users.count,
    #                                       time:        Time.now.to_i
  end

  def self.claims
    BonusClaim.where(bonus_type: self.name)
  end

  def self.claims_left?(user)
    claims.where(user_id: user.id).count < self.claim_limit
  end

end
