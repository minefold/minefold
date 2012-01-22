require 'spec_helper'

describe User do
  subject { Fabricate.build(:user) }

  specify { be_timestamped_document}
  specify { be_paranoid_document}

  specify { have_field(:email) }
  specify { have_field(:username) }
  specify { have_field(:safe_username) }
  specify { have_field(:slug) }

  specify { have_field(:host) }

  specify { have_field(:credits).of_type(Integer) }
  specify { have_field(:minutes_played).of_type(Integer).with_default_value_of(0) }

  specify { belong_to(:current_world).of_type(World).as_inverse_of(nil) }
  specify { reference_many(:created_worlds).of_type(World).as_inverse_of(:creator) }

  specify { validate_numericality_of(:credits)}
  specify { validate_numericality_of(:minutes_played).greater_than_or_equal_to(0) }

  describe 'credits' do
    it "gives FREE_HOURS by default" do
      free_credits = subject.class::FREE_HOURS.hours / subject.class::BILLING_PERIOD
      subject.credits.should == free_credits
    end
  end

  describe 'usernames' do
    specify { validate_presence_of(:username)}
    specify { validate_uniqueness_of(:safe_username)}

    specify { validate_length_of(:safe_username).within(1..16)}

    it "changes #safe_username when changing #username" do
      subject.username = ' FooBarBaz '
      subject.safe_username.should == 'foobarbaz'
    end
  end

  describe "referrals" do
    specify { validate_uniqueness_of(:referral_code) }

    it "should have a short referral code" do
      subject.save!
      subject.referral_code.length.should <= User::REFERRAL_CODE_LENGTH
    end

    specify { belong_to(:referrer).of_type(User).as_inverse_of(:referrals) }
    specify { reference_many(:referrals).of_type(User).as_inverse_of(:referrer) }
  end
end
