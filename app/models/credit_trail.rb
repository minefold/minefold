class CreditTrail
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :user
  field :delta, type: Integer
  field :src, type: String, default: 'sys'
  
  def self.log(user, delta)
    create(user: user, delta: delta)
  end
  
end
