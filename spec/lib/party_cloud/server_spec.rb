require './lib/party_cloud/server'

describe PartyCloud::Server do

  before do
    ENV['PARTY_CLOUD_TOKEN'] = 'foo:bar'
  end

  describe "#create" do

    it "calls out and stuff" do
      RestClient.stub(:post)
        .with('http://foo:bar@api.partycloud.com/servers', '')
        .and_return(JSON.generate({id: 'foo', created_at: Time.now}))

      expect(described_class.create.id).to eq('foo')
    end

  end

end
