class RewardsObserver < ActiveRecord::Observer
  observe :user
  
  def after_save(obj)
    case obj
    when User
      @user = obj
      
      if obj.facebook_uid_changed? and obj.facebook_uid_was == nil and obj.facebook_uid.present?
        claim! 'facebook linked'
      end
      
      
    end
  end
  
protected
  
  def claim!(reward)
    Reward.claim(reward, @user)
  end
  
end
