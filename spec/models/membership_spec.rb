 require 'spec_helper'

describe Membership do
  let(:world) { Fabricate.build(:world) }
  let(:user) { Fabricate.build(:user) }
  subject { world.memberships.new(user: user) }

  it { should be_embedded_in(:world) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_uniqueness_of(:user) }

  it { should have_field(:role).of_type(String) }
  it { should validate_inclusion_of(:role).to_allow(Membership::ROLES) }

  it "is valid without a role" do
    subject.role = nil
    subject.should be_valid
  end

  it "ops users" do
    subject.should_not be_op
    subject.op!
    subject.should be_op
  end
  
  it "enforces user uniqueness within world" do
    rando = Fabricate(:user)
    world.add_member(rando)
    world.save!
    
    another_world = Fabricate(:world)
    another_world.add_member(user)
    another_world.add_member(rando)
    another_world.save!
    another_world.valid?.should be_true
  end
end
