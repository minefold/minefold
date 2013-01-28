json.(server, :id, :name, :created_at, :updated_at)
json.state server.state_name
json.split_billing server.shared?
json.players PartyCloud.players_online(server.party_cloud_id)
