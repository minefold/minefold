class PartyCloud::World
  include Mongoid::Document
  store_in collection: 'worlds'

  field :ceator_id, type: Moped::BSON::ObjectId
  field :parent_id, type: Moped::BSON::ObjectId

  field :slug, type: String
  field :world_data_file, type: String
  field :funpack, type: String

  field :opped_player_ids, type: Array
  field :whitelisted_player_ids, type: Array
  field :banned_player_ids, type: Array
end
