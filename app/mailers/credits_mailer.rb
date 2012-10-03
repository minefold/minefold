class CreditsMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
  
  add_template_helper ActionView::Helpers::DateHelper


  def low_credits(user_id)
  end
  
  def no_credits(user_id)
  end
  
  def receipt(user_id, charge_id)
    @user = User.find(user_id)
    @charge = Stripe::Charge.find(charge_id)
  end

end
