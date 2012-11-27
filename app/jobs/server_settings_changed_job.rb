class ServerSettingsChangedJob < Job
  @queue = :high

  def initialize(id, change)
    @server = Server.find_by_party_cloud_id(id)
    @change = change
  end

  def perform!
    # hack for whitelist_add, whitelist_remove, blacklist_add, blacklist_remove, ops_add, ops_remove
    if @change['setting'] =~ /([a-z]+)_add/
      set = @server.settings[$1].split("\n")
      @server.settings[$1] = (set | [@change['value']]).uniq.join("\n")

    elsif @change['setting'] =~ /([a-z]+)_remove/
      set = @server.settings[$1].split("\n")
      @server.settings[$1] = (set - [@change['value']]).uniq.join("\n")

    else
      @server.settings[@change['setting']] = @change['value']
    end
    @server.save!
  end

end
