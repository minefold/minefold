require 'spec_helper'

describe ProcessChatJob do
  let(:world) { Fabricate(:world).tap{|w| w.stub :broadcast } }

  it "should create chat event" do
    ProcessChatJob.perform(world.id, world.creator.minecraft_player.username, 'oh hai!')

    World.find(world.id).events.first.text.should == 'oh hai!'
  end
end
