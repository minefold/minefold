class Bonus < ActiveRecord::Base

  class_attribute :coins
  self.coins = 0

  belongs_to :user

  validate :validate_claimable?

  after_create :give!

  def self.claim!(user)
    create(user: user)
  end

  def self.pretty_name
    name.demodulize.underscore.humanize
  end


  def validate_claimable?
    errors.add(:base, 'Not claimable') unless claimable?
  end

  def claimable?
    self.class.where(user_id: user.id).count < 1
  end

  def coins
    self.class.coins
  end

  def give!
    user.increment_coins!(coins)
    track!
  end


# private

# TODO Move to controller (mostly to get the request IP so we can get good location information in Mixpanel).
  def track!
    MixpanelAsync.track(user.distinct_id, 'Bonus claimed',
      bonus: self.class.pretty_name,
      coins: coins,
      time:  Time.now.to_i
    )
  end

end
