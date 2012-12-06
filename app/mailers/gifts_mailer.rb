class GiftsMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers

  add_template_helper ActionView::Helpers::DateHelper

  def receipt(gift_id)
    @gift = Gift.find(gift_id)

    mail to: @gift.email,
         subject: "Minefold Gift Receipt"
  end

end
