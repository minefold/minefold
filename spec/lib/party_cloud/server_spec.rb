require './lib/party_cloud/server'

describe PartyCloud::Server do

  before do
    ENV['PARTY_CLOUD_TOKEN'] = 'foo:bar'
  end

  describe "#create" do

    it "calls out and stuff" do
      funpack = stub(:funpack, party_cloud_id: '50a976ec7aae5741bb000001')

      RestClient.stub(:post)
        .with('/servers',
          funpack: '9ed10c25-60ed-4375-8170-29f9365216a0',
          region:  '71519ec0-1515-42b9-b2f6-a24c151a6247',
          name:    'sup'
        ).and_return(JSON.generate({id: 'foo', created_at: Time.now}))

      expect(described_class.create(funpack, 'sup').id).to eq('foo')
    end

  end

end
