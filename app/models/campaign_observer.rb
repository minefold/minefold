class CampaignObserver < Mongoid::Observer
  observe :user
  
  def after_create user
    subscribe user
  end
  
  def after_update user
    if user.notifications_was and user.notifications_changed? and 
        user.notifications_was['campaign'] != user.notifications['campaign']
      user.notify?(:campaign) ? subscribe(user) : unsubscribe(user)
    end
    
    update_subscription user if user.username_changed?
  end
  
  def subscribe user
    if ENV['CAMPAIGN_MONITOR_API_KEY']
      Resque.enqueue SubscribePlayerJob, user.id
    end
  end
  
  def unsubscribe user
    if ENV['CAMPAIGN_MONITOR_API_KEY']
      Resque.enqueue UnsubscribePlayerJob, user.id
    end
  end
  
  def update_subscription user
    if ENV['CAMPAIGN_MONITOR_API_KEY']
      Resque.enqueue UpdateSubscriptionJob, user.id
    end
  end
end