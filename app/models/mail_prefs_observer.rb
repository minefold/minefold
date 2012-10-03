class MailPrefsObserver < ActiveRecord::Observer
  observe :user
  
  def before_create(user)
    user.newsletter_mailer ||= true
    user.server_mailer ||= true
    user.session_mailer ||= true
  end
  
end
  