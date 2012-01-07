require 'spec_helper'

describe User do
  let(:user) {build(:user)}

  it { should be_timestamped_document}
  it { should be_paranoid_document}

  it { should have_field(:email) }
  it { should have_field(:username) }
  it { should have_field(:safe_username) }
  it { should have_field(:slug) }

  it { should have_field(:host) }

  it { should have_field(:credits).of_type(Integer) }
  it { should have_field(:minutes_played).of_type(Integer).with_default_value_of(0) }

  it { should belong_to(:current_world).of_type(World).as_inverse_of(nil) }
  it { should reference_many(:created_worlds).of_type(World).as_inverse_of(:creator) }

# Validations

  it { should validate_numericality_of(:credits)}
  it { should validate_numericality_of(:minutes_played).greater_than_or_equal_to(0) }

  describe 'credits' do
    it "gives FREE_HOURS by default" do
      user.credits.should == (User::FREE_HOURS.hours / User::BILLING_PERIOD)
    end
  end

  describe 'usernames' do
    it { should validate_presence_of(:username)}
    it { should validate_uniqueness_of(:safe_username)}

    it { should validate_length_of(:safe_username).within(1..16)}

    it "changes #safe_username when changing #username" do
      user.username = ' FooBarBaz '
      user.safe_username.should == 'foobarbaz'
    end
  end

  describe "referrals" do
    it { should validate_uniqueness_of(:referral_code) }

    it "should have a short referral code" do
      user.save!
      user.referral_code.length.should == User::REFERRAL_CODE_LENGTH
    end

    it { should belong_to(:referrer).of_type(User).as_inverse_of(:referrals) }
    it { should reference_many(:referrals).of_type(User).as_inverse_of(:referrer) }
  end
end
