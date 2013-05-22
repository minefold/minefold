require 'spec_helper'

describe Server do
  describe "#set_max_players" do
    let(:plan) { Plan.make!(bolts: 2) }
    let(:creator) { User.make!(subscription: Subscription.new(plan: plan, expires_at: Time.now + 30.days)) }
    let(:funpack) { Funpack.make!(player_allocations: [12, 24]) }
    let(:server) { Server.make!(creator: creator, funpack: funpack) }

    it "is called on create" do
      server.settings['max-players'].should == 24
    end

  end
end
