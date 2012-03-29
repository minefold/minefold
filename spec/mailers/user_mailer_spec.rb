require "spec_helper"

describe UserMailer do
  let(:user) { Fabricate(:user) }

  describe "reminder" do
    subject { UserMailer.reminder(user.id) }

    its(:to) { should include(user.email) }

    its(:body) { should include(user.username) }
    its(:body) { should include(pro_account_url) }
  end

  describe "welcome" do
    subject { UserMailer.welcome(user.id) }

    its(:to) { should include(user.email) }
    its(:body) { should include(user.username) }
  end
  
  describe "credits_reset" do
    subject { UserMailer.credits_reset(user.id) }

    its(:to) { should include(user.email) }
    its(:body) { should include(user.username) }
    its(:body) { should include(pro_account_url) }
  end
  
  describe "invite_player" do
    let(:world) { Fabricate :world }
    let(:invitor) { Fabricate :user }
    subject { UserMailer.invite(invitor.minecraft_player.id, world.id, 'dave@minefold.com') }

    its(:to) { should include('dave@minefold.com') }
    its(:body) { should include(invitor.minecraft_player.username) }
  end
  
end
