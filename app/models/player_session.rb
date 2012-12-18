class PlayerSession < ActiveRecord::Base
  attr_accessible :started_at, :ended_at

  belongs_to :server_session
  belongs_to :account

  default_scope order(:created_at).reverse_order
  scope :active, where(ended_at: nil)

  def finish(time)
    self.ended_at = time
  end

end
