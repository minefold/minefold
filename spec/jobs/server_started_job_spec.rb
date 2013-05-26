require 'spec_helper'

describe ServerStartedJob do

  let(:ts) { Time.now }
  let(:server) { Server.make! }

  before do
    Pusher.stub(:trigger)
  end

  subject {
    s = described_class.new(server.party_cloud_id, '1.2.3.4', 1337, ts.to_i)
    s.server.stub(address: stub, game: stub(name: 'Foo'))
    s
  }

  describe "#perform" do
    it "creates session" do
      subject.perform
      expect(subject.server.sessions.current.started_at.to_i).to eq(ts.to_i)
    end

    it "sets session to earlier start" do
      subject.perform

      earlier = 1.hour.ago
      job = subject.dup
      job.stub(started_at: earlier)
      job.perform

      expect(subject.server.sessions.current.started_at.to_i).to eq(earlier.to_i)
    end

    it "sets host" do
      subject.perform
      expect(subject.server.host).to eq('1.2.3.4')
      expect(subject.server.port).to eq(1337)
    end

  end

end
