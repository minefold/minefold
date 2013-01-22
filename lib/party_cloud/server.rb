require 'json'
require 'restclient'

module PartyCloud
  class Server

    attr_reader :id

    def self.create
      url = "http://#{ENV['PARTY_CLOUD_TOKEN']}@api.partycloud.com/servers"
      response = RestClient.post(url, '')
      new(JSON.parse(response)['id'])
    end

    def initialize(id)
      @id = id
    end

  end
end
