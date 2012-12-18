class ChangeUserSessionsToPlayerSessions < ActiveRecord::Migration

  def change
    rename_table :user_sessions, :player_sessions
    rename_column :player_sessions, :user_id, :account_id
    remove_column :player_sessions, :username
  end

end
