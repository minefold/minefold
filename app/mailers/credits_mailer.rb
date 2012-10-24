class CreditsMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
  
  add_template_helper ActionView::Helpers::DateHelper


  def low_credits(user_id)
  end
  
  def no_credits(user_id)
  end
  
  def receipt(user_id, charge_id, credit_pack_id)
    @user = User.find(user_id)
    @charge = Stripe::Charge.retrieve(charge_id)
    @credit_pack = CreditPack.find(credit_pack_id)
    
    mail to: @user.email,
         subject: "Minefold Receipt #{@charge.id}"
  end

end
