class UserObserver < Mongoid::Observer
  def after_create user
    if ENV['CAMPAIGN_MONITOR_API_KEY']
      Resque.enqueue SubscribePlayerJob, user.id
    end
  end
end
