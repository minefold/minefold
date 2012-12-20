require 'spec_helper'

describe ServerStartedJob do
  context 'game with routing' do
    let(:game) { Game.make!(routing: true) }
    let(:funpack) { Funpack.make!(game: game) }
    let(:server) { Server.make!(funpack: funpack) }

    context 'initial start' do
      it 'creates session' do
        ts = Time.now
        ServerStartedJob.new(
          server.party_cloud_id, '', '', ts.to_i
        ).perform!

        server.sessions.current.started_at.to_i.should eq(ts.to_i)
      end
    end

    context 'second start before first start' do
      it 'sets session to earlier start' do
        first = Time.now
        second = Time.now - 60

        job = ServerStartedJob.new(
          server.party_cloud_id, '', '', first.to_i
        ).perform!

        job = ServerStartedJob.new(
          server.party_cloud_id, '', '', second.to_i
        ).perform!

        server.sessions.current.started_at.to_i.should eq(second.to_i)
      end
    end
  end

  context 'game without routing' do
    let(:game) { Game.make!(routing: false) }
    let(:funpack) { Funpack.make!(game: game) }
    let(:server) { Server.make!(funpack: funpack) }

    it 'sets host' do
      ts = Time.now
      
      jerb = ServerStartedJob.new(
        server.party_cloud_id, '1.2.3.4', '1337', ts.to_i
      )
      jerb.perform!
      
      jerb.server.host.should eq('1.2.3.4')
      jerb.server.port.should eq(1337)
    end
  end
end
