class AddUserAttributesToSessions < ActiveRecord::Migration
  def change
    change_table :server_sessions do |t|
      t.references :user
    end

    change_table :player_sessions do |t|
      t.string :nick
      t.references :user
    end
  end
end
