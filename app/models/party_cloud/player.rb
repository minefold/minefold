class PartyCloud::Player
  include Mongoid::Document
  store_in collection: 'minecraft_players'

  field :slug, type: String
  field :username, type: String

  field :distinct_id, type: String
  field :unlock_code, type: String

  field :last_remote_ip, type: String

  field :minutes_played, type: Integer
end
