require 'spec_helper'

describe Membership do
  let(:world) {build :world}
  let(:user) {build :user}
  let(:membership) {
    world.memberships.new user: user
  }

  it {should be_embedded_in(:world)}
  it {should belong_to(:user)}
  it {should validate_presence_of(:user)}
  it {should validate_uniqueness_of(:user)}

  it {should have_field(:role).of_type(String)}
  it {should validate_inclusion_of(:role).to_allow(Membership::ROLES)}

  it "is valid without a role" do
    membership.role = nil
    membership.should be_valid
  end

  it "ops users" do
    membership.should_not be_op
    membership.op!
    membership.should be_op
  end

end
