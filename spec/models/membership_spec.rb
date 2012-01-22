 require 'spec_helper'

describe Membership do
  let(:world) { Fabricate.build(:world) }
  let(:user) { Fabricate.build(:user) }
  subject { world.memberships.new(user: user) }

  specify { be_embedded_in(:world) }
  specify { belong_to(:user) }
  specify { validate_presence_of(:user) }
  specify { validate_uniqueness_of(:user) }

  specify { have_field(:role).of_type(String) }
  specify { validate_inclusion_of(:role).to_allow(Membership::ROLES) }

  it "is valid without a role" do
    subject.role = nil
    subject.should be_valid
  end

  it "ops users" do
    subject.should_not be_op
    subject.op!
    subject.should be_op
  end
end
