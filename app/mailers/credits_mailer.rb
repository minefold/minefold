class CreditsMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers

  add_template_helper ActionView::Helpers::DateHelper


  def low_credits(user_id)
    @resource = User.find(user_id)

    mail to: @resource.email,
         subject: "Your Minefold credits are low"
  end

  def no_credits(user_id)
    @resource = User.find(user_id)

    mail to: @resource.email,
         subject: "You have run out of Minefold credits"
  end

  def receipt(user_id, charge_id, credit_pack_id)
    @resource = User.find(user_id)
    @charge = Stripe::Charge.retrieve(charge_id)
    @credit_pack = CreditPack.find(credit_pack_id)

    mail to: @resource.email,
         subject: "Minefold Receipt #{@charge.id}"
  end

end
