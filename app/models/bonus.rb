class Bonus < ActiveRecord::Base
  belongs_to :user

  class_attribute :mins

  def self.coins
    mins
  end

  serialize :data, ActiveRecord::Coders::Hstore
  validate :validate_claimable?

  def self.give_to(user)
    create(user: user).give!
  end

  def self.pretty_name
    name.demodulize.underscore.humanize
  end

  def validate_claimable?
    errors.add(:base, 'Not claimable') unless claimable?
  end

  # Override

  def claimed?
    !coins.zero?
  end

  def claimable?
    self.class.where(user_id: user.id).count < 1
  end

  def mins
    self.class.mins
  end

  def give!
    transaction do
      user.extend_trial!(mins)
      update_attribute(:coins, mins)
    end

    track!
  end


# private

  # TODO Move to controller (mostly to get the request IP so we can get good location information in Mixpanel).
  def track!
    Analytics.track(
      user_id: user.id,
      event: 'Bonus claimed',
      properties: {
        bonuse: self.class.pretty_name,
        mins: coins
      }
    )
  end

end
