class Reward < ActiveRecord::Base
  attr_accessible :credits, :name
  
  has_many :reward_claims
  has_many :users, :through => :reward_claims
  
  def self.claim(name, user)
    reward = where(name: name).first!
    
    if not reward.users.include?(user)
      user.increment_credits!(reward.credits)
      reward.reward_claims.create!(user: user)
    end
  end
  
end
