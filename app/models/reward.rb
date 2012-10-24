class Reward < ActiveRecord::Base
  attr_accessible :credits, :name
  
  has_many :reward_claims
  has_many :users, :through => :reward_claims
  
  # TODO Refactor this method into instance methods
  def self.claim(name, user)
    reward = where(name: name).first
    
    if not reward
      return Rails.logger.warn("missing reward #{name.inspect}")
    end
    
    if not reward.users.include?(user)
      user.increment_credits!(reward.credits)
      reward.reward_claims.create!(user: user)
      
      Mixpanel.track_async 'claimed reward', distinct_id: user.distinct_id,
                                             reward_id: reward.id,
                                             reward: reward.name,
                                             time: Time.now.to_i
    end
  end
  
end
