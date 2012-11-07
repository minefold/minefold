class RenameSuperServersToSharedServers < ActiveRecord::Migration

  def change
    rename_column :servers, :super_server, :shared
    rename_column :games, :super_servers, :shared_servers
  end

end
