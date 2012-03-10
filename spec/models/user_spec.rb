require 'spec_helper'

describe User do
  subject { Fabricate.build(:user) }

  it { should be_timestamped_document }
  it { should be_paranoid_document }


# ---
# Minecraft Account

  it { should have_one(:minecraft_account) }



  it { should have_field(:email) }


  it { should have_field(:host) }

  it { should have_field(:credits).of_type(Integer) }
  it { should have_field(:minutes_played).of_type(Integer).with_default_value_of(0) }

  it { should belong_to(:current_world).of_type(World).as_inverse_of(nil) }
  it { should reference_many(:created_worlds).of_type(World).as_inverse_of(:creator) }

  it { should validate_numericality_of(:credits)}
  it { should validate_numericality_of(:minutes_played).greater_than_or_equal_to(0) }

  describe 'credits' do
    it "gives FREE_HOURS by default" do
      free_credits = subject.class::FREE_HOURS.hours / subject.class::CREDIT_PERIOD
      subject.credits.should == free_credits
    end

  end

  describe "referrals" do
    it { should validate_uniqueness_of(:referral_code) }

    it "should have a short referral code" do
      subject.save!
      subject.referral_code.length.should == User::REFERRAL_CODE_LENGTH
    end

    it { should belong_to(:referrer).of_type(User).as_inverse_of(:referrals) }
    it { should reference_many(:referrals).of_type(User).as_inverse_of(:referrer) }
  end
end
