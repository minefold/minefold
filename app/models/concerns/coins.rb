module Concerns::Coins
  extend ActiveSupport::Concern

  included do
    validates_presence_of :coins
    validates_numericality_of :coins
  end

  # Atomically increment coins. Doesn't update the model's internal state.
  def increment_coins!(n)
    self.class.update_counters(self.id, coins: n) == 1
  end

  def spend_coins!(n)
    increment_coins!(-n)
    track_spend(n)
  end

# private

  def track_spend(n)
    MixpanelAsync.engage(self.distinct_id, '$add' => {'Time' => (-n)})
    Librato.increment('user.coins.spent', by: n, sporadic: true)
  end

end
