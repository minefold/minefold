require "spec_helper"

describe UserMailer do
  let(:user) { Fabricate(:user) }

  describe "reminder" do
    subject { UserMailer.reminder(user.id) }

    its(:to) { include(user.email) }

    its(:body) { include(user.username) }
    its(:body) { include(pro_account_url) }
  end

  describe "welcome" do
    subject { UserMailer.welcome(user.id) }

    its(:to) { include(user.email) }
    its(:body) { include(user.username) }
  end
end
