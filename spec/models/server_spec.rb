require 'spec_helper'

describe Server do
  let(:creator) { User.make! }

  describe "#add_creator_to_watchers" do
    let(:server) { Server.make!(creator: creator) }

    it "is called on create" do
      expect(server.watchers).to include(creator)
    end

  end
  
  describe 'name changed' do
    let(:server) { Server.make!(:tf2) }

    it 'should trigger callback for funpacks' do
      server.name = 'MAXIMUM KILLZ!'
      server.save!
      
      server.settings['hostname'].should == 'MAXIMUM KILLZ! (minefold.com)'
    end
  end

end
