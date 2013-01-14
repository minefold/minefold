require 'spec_helper'

describe ServerStartedJob do

  let(:ts) { Time.now }
  let(:server) { Server.make! }

  context 'game with routing' do

    let(:game) { stub(name: 'Name', :routable? => false) }

    subject {
      s = ServerStartedJob.new(server.party_cloud_id, '', '', ts.to_i)
      s.server.stub(game: game)
      s
    }

    context 'initial start' do
      it 'creates session' do
        subject.perform
        expect(subject.server.sessions.current.started_at.to_i).to eq(ts.to_i)
      end
    end

    context 'second start before first start' do
      it 'sets session to earlier start' do
        subject.perform
        earlier = 1.hour.ago
        job = ServerStartedJob.new(server.party_cloud_id, '', '', earlier.to_i)
        job.server.stub(game: game)
        job.perform

        expect(subject.server.sessions.current.started_at.to_i).to eq(earlier.to_i)
      end
    end
  end

  context 'game without routing' do

    let(:game) { stub(name: 'Name', :routable? => false) }

    subject {
      s = ServerStartedJob.new(
        server.party_cloud_id, '1.2.3.4', '1337', ts.to_i
      )
      s.server.stub(game: game)
      s
    }

    it 'sets host' do
      subject.perform
      expect(subject.server.host).to eq('1.2.3.4')
      expect(subject.server.port).to eq(1337)
    end
  end
end
