class MailPrefsObserver < ActiveRecord::Observer
  observe :user
  
  def before_create(user)
    user.membership_mailer ||= true
    user.membership_request_mailer ||= true
    user.newsletter_mailer ||= true
    user.server_mailer ||= true
    user.session_mailer ||= true
  end
  
end
  