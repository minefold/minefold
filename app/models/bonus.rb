class Bonus < ActiveRecord::Base

  class_attribute :credits
  self.credits = 0

  belongs_to :user

  validate :validate_claimable?

  after_create :give!

  def self.claim!(user)
    create(user: user)
  end

  def validate_claimable?
    errors.add(:base, 'Not claimable') unless claimable?
  end

  def claimable?
    user.bonuses.where(type: self.class).count < 1
  end

  def credits
    self.class.credits
  end

  def give!
    user.increment_credits!(credits)
    track!
  end


# private

  def track!
    Mixpanel.async_track 'bonus claimed', distinct_id: user.distinct_id,
                                          bonus:       self.class.name,
                                          credits:     credits,
                                          time:        Time.now.to_i
  end

end
