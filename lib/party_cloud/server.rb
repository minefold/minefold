require 'json'
require 'restclient'

module PartyCloud
  class Server

    attr_reader :id

    def self.legacy_funpack_mapping
      {
        # minecraft
        '50a976ec7aae5741bb000001' => '9ed10c25-60ed-4375-8170-29f9365216a0',
        # bukkit-essentials
        '50a976fb7aae5741bb000002' => 'c942cbc1-05b2-4928-8695-b0d2a4d7b452',
        # tekkit
        '50a977097aae5741bb000003' => '4bfcf174-e630-43d4-a17a-3c0d1491bae4',
        # team-fortress-2
        '50bec3967aae5797c0000004' => '3fe55a6d-36fe-4e27-9ba3-1309e6405aa5',
        # feed-the-beast-direwolf20
        '512159a67aae57bf17000005' => '2f203313-cc51-4ae2-88b5-9d35620d8ef2',
        # tekkit-lite
        '5126be367aae5712a4000007' => 'a3ef2208-65df-4bc0-934c-e80e1bd7914f'
      }
    end

    def self.create(funpack, name)
      url = "http://#{ENV['PARTY_CLOUD_TOKEN']}@api.partycloud.com/servers"
      response = RestClient.post(url,
        funpack: legacy_funpack_mapping[funpack.party_cloud_id],
        funpack: '9ed10c25-60ed-4375-8170-29f9365216a0',
        region:  '71519ec0-1515-42b9-b2f6-a24c151a6247',
        name:    name
      )
      new(JSON.parse(response)['id'])
    end

    def initialize(id)
      @id = id
    end

  end
end
