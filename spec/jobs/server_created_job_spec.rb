require 'spec_helper'

describe ServerCreatedJob do

  let(:server) { Server.make! }

  subject {
    described_class.new(server.id, 'abc')
  }

  describe "#perform!" do

    it "sets the server's party_cloud_id" do
      expect {
        subject.perform!
      }.to change { subject.server.party_cloud_id }.to('abc')
    end

    it "saves the record" do
      subject.server.should_receive(:save!)
      subject.perform!
    end

  end

end
