require 'test_helper'

class NotificationsObserverTest < ActiveSupport::TestCase

  [CampaignMailer,
   ServerMailer,
   SessionMailer].each do |mailer|

    test "#before_create subscribes user to #{mailer.name}" do
      user = User.make!
      assert user.send_notification_for?(mailer)
    end

  end

end
