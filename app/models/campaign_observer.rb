class CampaignObserver < Mongoid::Observer
  observe :user

  def after_create(user)
    subscribe(user)
  end

  def after_update(user)
    if user.notifications_was and user.notifications_changed? and
        user.notifications_was['campaign'] != user.notifications['campaign']
      user.notify?(:campaign) ? subscribe(user) : unsubscribe(user)
    end

    # if user.minecraft_account_changed?
    #   update_subscription(user)
    # end
  end

  def subscribe(user)
    Resque.enqueue(SubscribePlayerJob, user.id)
  end

  def unsubscribe(user)
    Resque.enqueue(UnsubscribePlayerJob, user.id)
  end

  def update_subscription(user)
    Resque.enqueue(UpdateSubscriptionJob, user.id)
  end

end
