require 'json'
require 'restclient'

module PartyCloud
  class Server

    attr_reader :id

    def self.create(funpack, name)
      url = "#{ENV['TRON_URL']}/servers"
      begin
        response = RestClient.post(url,
          funpack: funpack.party_cloud_id,
          region:  '71519ec0-1515-42b9-b2f6-a24c151a6247',
          name:    name
        )
        payload = JSON.parse(response)
        new(payload['legacyId'] || payload['id'])
      rescue RestClient::ServerBrokeConnection
        # retry 5 times...

        @retries ||= 0
        if @retries < 5
          @retries += 1
          retry
        else
          raise
        end
      end
    end

    def initialize(id)
      @id = id
    end

  end
end
