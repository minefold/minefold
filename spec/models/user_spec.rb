require 'spec_helper'

describe User do

  it { should be_timestamped_document}
  it { should be_paranoid_document}


  it {should have_field(:email)}
  it {should have_field(:username)}
  it {should have_field(:safe_username)}
  it {should have_field(:slug)}

  it {should have_field(:staff).of_type(Boolean).with_default_value_of(false)}

  it {should have_field(:credits).of_type(Integer).with_default_value_of(0)}
  it {should have_field(:minutes_played).of_type(Integer).with_default_value_of(0)}
  it {should embed_many(:credit_events)}

  it {should reference_many(:orders)}

  it {should reference_one(:current_world).of_type(World)}
  it {should reference_many(:worlds)}

  it {should have_field(:referrals_sent).of_type(Integer).with_default_value_of(0)}
  it {should embed_many(:referrals)}
  it {should embed_one(:referral)}


# VALIDATIONS

  it { should validate_uniqueness_of(:email).case_insensitive}
  it { should validate_uniqueness_of(:username).case_insensitive}
  it { should validate_confirmation_of(:password)}
  it { should validate_numericality_of(:credits).greater_than_or_equal_to(0)}
  it { should validate_numericality_of(:minutes_played).greater_than_or_equal_to(0)}
  it { should validate_numericality_of(:referrals_sent).greater_than_or_equal_to(0)}


# CREDITS

  it "gives FREE_CREDITS by default" do
    user = User.new

    free_credits = User::FREE_HOURS.hours / User::BILLING_PERIOD

    user.credits.should == free_credits
    user.credit_events.size.should == 1
    user.credit_events.first.delta.should == free_credits
  end

  it "#hours is the remaining number of hours" do
    user = User.new(credits: 60)
    user.hours.should == 1
    user.credits = 120
    user.hours.should == 2
  end

  it "#minutes is the remaining minutes from the hour" do
    user = User.new
    user.credits = 1
    user.minutes.should == 1
    user.credits = 61
    user.minutes.should == 1
  end


# AUTHENTICATION

  it "#find_for_database_authentication checks both username and email"

# REFERRALS



end