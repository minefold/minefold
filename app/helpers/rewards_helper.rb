module RewardsHelper

  def render_reward_for(reward_name, user, &blk)
    reward = Reward.where(name: reward_name).first!
    
    if not user.rewards.include?(reward)
      yield(reward)
    end
  end

end
