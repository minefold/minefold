require 'spec_helper'

describe PlayerOppedJob do
  let(:world) { Fabricate(:world) }
  let(:user) { Fabricate(:user) }

  before {
    world.add_member(user)
  }

  it "makes the player an op" do
    subject.process! world, user
    world.ops.should include(user)
  end
end
