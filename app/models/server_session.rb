class ServerSession < ActiveRecord::Base
  attr_accessible :started_at, :ended_at

  belongs_to :server

  default_scope order(:created_at).reverse_order

  scope :active, where(ended_at: nil)

  has_many :player_sessions, :autosave => true

  def finish(time)
    self.ended_at = time

    player_sessions.each do |session|
      session.finish(time)
    end
  end


  after_create :create_activity

  def create_activity
    Activities::Played.publish(self)
  end

end
