json.(server, :id, :name, :created_at, :updated_at)

json.state         server.state_name
json.address       server.address.to_s
json.split_billing server.shared?

json.players       PartyCloud.players_online(server.party_cloud_id)
