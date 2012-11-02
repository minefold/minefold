class NotificationsObserver < ActiveRecord::Observer
  observe :user
  
  def before_create(user)
    user.campaign_mailer ||= true
    user.server_mailer ||= true
    user.session_mailer ||= true
  end
  
end
  