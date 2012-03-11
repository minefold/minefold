require 'spec_helper'

describe PlayerOppedJob do
  let(:world) { Fabricate(:world) }
  let(:account) { Fabricate(:minecraft_account) }

  it "adds player to ops" do
    subject.process! world, user
    world.ops.should include(account)
  end
end
