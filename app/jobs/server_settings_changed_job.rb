class ServerSettingsChangedJob < Job
  @queue = :high

  attr_reader :server, :transform

  def initialize(timestamp, server_party_cloud_id, transform)
    @server = Server.unscoped.find_by_party_cloud_id(server_party_cloud_id)
    @transform = transform
  end

  def perform
    case
    when key = transform['add']
      set = (server.settings[key] || "").split("\n")
      server.settings[key] = (set | [transform['value']]).uniq.join("\n")
      
      puts "add:#{key} #{transform['value']}   =>  #{server.settings[key]}"
      

    when key = transform['remove']
      set = (server.settings[key] || "").split("\n")
      server.settings[key] = (set - [transform['value']]).uniq.join("\n")

    when key = transform['set']
      server.settings[key] = transform['value']
    end

    server.save!
  end

end
