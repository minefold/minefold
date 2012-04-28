class CampaignMailer < ActionMailer::Base

  def downtime_20120424(user_id)
    @user = User.find(user_id)

    mail to: @user.email,
         subject: "Recent Minefold downtime",
         from: "Minefold <team@minefold.com>"
  end

  class Preview < ::MailView

    def downtime_20120424
      user = User.chris
      CampaignMailer.downtime_20120424(user.id)
    end
  end
end