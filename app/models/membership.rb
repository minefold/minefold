class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = [:op]

  embedded_in :world

  belongs_to :user
  validates_presence_of :user
  validates_uniqueness_of :user

  field :role, type: Symbol
  validates_inclusion_of :role, in: ROLES, allow_nil: true

  scope :ops, where(role: :op)

  def op?
    role == :op
  end

  def op!
    self.role = :op
  end

end
