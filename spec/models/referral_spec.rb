require 'spec_helper'

describe Referral do

  it {should have_field(:email).of_type(String)}
  it {should have_field(:claimed).of_type(Boolean).with_default_value_of(false)}
  it {should have_field(:code).of_type(String)}

  it {should be_embedded_in(:creator).of_type(User)}
  it {should belong_to(:user)}

  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}
  it {should validate_uniqueness_of(:code)}
  it {should validate_uniqueness_of(:user)}


  it "generates a random code" do
    referral = Referral.new
    referral.code.length.should == Referral::CODE_LENGTH
    other = Referral.new
    referral.code.should_not == other.code
  end

  it "downcases and strips emails" do
    referral = Referral.new
    referral.email = ' CHRIS@MINEFOlD.COM '
    referral.email.should == 'chris@minefold.com'
  end

end
