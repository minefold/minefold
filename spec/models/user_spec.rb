require 'spec_helper'

describe User do
  subject { Fabricate.build(:user, minecraft_player: nil) }

  it { should be_timestamped_document }
  it { should be_paranoid_document }


# ---
# Minecraft Account

  it { should have_one(:minecraft_player) }


# ---
# Identity


  it "#username" do
    subject.username.should be_nil

    player = Fabricate.build(:minecraft_player)

    subject.minecraft_player = player
    subject.username.should == player.username
  end


# ---
# Flags


  it { should have_field(:admin).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:beta).of_type(Boolean).with_default_value_of(false) }


# ---
# Authentication


  # TODO Fill in Devise specs


# ---
# Email


  it { should have_field(:email) }


# ---
# OAuth


  # TODO Fill in OAuth specs


# ---
# Credits

  it ".hours_to_credits" do
    subject.class.hours_to_credits(0).should == 0
    subject.class.hours_to_credits(1).should == 60
    subject.class.hours_to_credits(2).should == 120
  end

  it { should have_field(:credits).of_type(Integer) }
  it { should have_field(:last_credit_reset).of_type(DateTime) }

  it "#increment_credits!"
  it "#increment_hours!"
  it "#hours_left"


# ---
# Billing


  it { should have_field(:plan_expires_at).of_type(DateTime) }

  it "has free time on creation" do
    subject.credits.should == User.hours_to_credits(User::FREE_HOURS)
  end

  it "isn't Pro by default" do
    subject.should_not be_pro
  end

  it "is Pro if beta user" do
    subject.beta = true
    subject.should be_pro
  end

  it "isn't Pro if plan has expired" do
    subject.plan_expires_at = 1.hour.ago
    subject.should_not be_pro
  end

  it "is Pro if plan expires in the future" do
    subject.plan_expires_at = 1.hour.from_now
    subject.should be_pro
  end

  it "#extend_plan_by works with no plan" do
    subject.plan_expires_at = nil

    Timecop.freeze do
      subject.extend_plan_by 1.minute
      subject.plan_expires_at.should == 1.minute.from_now
    end
  end

  # this test fails weirdly:
  # expected: Sat, 01 Jan 0000 08:02:00 UTC +00:00
  #      got: Thu, 01 Jan 0000 08:02:00 +0000 (using ==)
  # it "#extend_plan_by works with an existing plan" do
  #   Timecop.freeze do
  #     subject.plan_expires_at = 1.minute.from_now
  #     subject.extend_plan_by 1.minute
  #     subject.plan_expires_at.should == 2.minutes.from_now
  #   end
  # end


# ---
# Settings


  it { should have_field(:notifications).of_type(Hash) }
  it { should have_field(:last_world_started_mail_sent_at).of_type(DateTime) }

  it "#notify?"


# ---
# Invites

  it { should have_field(:invite_token).of_type(String) }
  it { should validate_uniqueness_of(:invite_token) }

  it { should belong_to(:referrer) }
  it { should reference_many(:referrals) }


# ---
# Worlds


  it { should have_many(:created_worlds).of_type(World).as_inverse_of(:creator) }

  it { should belong_to(:current_world).of_type(World).as_inverse_of(nil) }


# ---
# Photos


  # it { should have_many(:photos).as_inverse_of(:creator) }


end
