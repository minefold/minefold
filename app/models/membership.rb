class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = ['op']

  embedded_in :world

  belongs_to :user
  validates_presence_of :user
  validates_uniqueness_of :user

  field :role, type: String
  validates_inclusion_of :role, in: ROLES, allow_nil: true
  scope :ops, where(role: 'op')

  def op?
    role == 'op'
  end

  def op!
    self.role = 'op'
  end

  field :minutes_played, type: Integer, default: 0
  field :last_played_at, type: DateTime

  def played?
    not last_played_at.nil?
  end

end
