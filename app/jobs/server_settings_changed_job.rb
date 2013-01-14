class ServerSettingsChangedJob < Job
  @queue = :high

  attr_reader :server
  attr_reader :key, :value

  def initialize(server_party_cloud_id, key, value=nil)
    @server = Server.unscoped.find_by_party_cloud_id(server_party_cloud_id)

    if value.nil?
      change = key
      @key, @value = change['setting'], change['value']
    else
      @key, @value = key, value
    end
  end

  def perform
    # hack for whitelist_add, whitelist_remove, blacklist_add, blacklist_remove, ops_add, ops_remove
    if key =~ /([a-z]+)_add/
      set = (server.settings[$1] || "").split("\n")
      server.settings[$1] = (set | [value]).uniq.join("\n")

    elsif key =~ /([a-z]+)_remove/
      set = (server.settings[$1] || "").split("\n")
      server.settings[$1] = (set - [value]).uniq.join("\n")

    else
      server.settings[key] = value
    end

    server.save!
  end

end
