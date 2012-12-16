class RenameSessionsToServerSessions < ActiveRecord::Migration

  def change
    rename_table :sessions, :server_sessions
  end

end
