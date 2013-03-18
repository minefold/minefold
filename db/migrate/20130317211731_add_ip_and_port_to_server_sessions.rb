class AddIpAndPortToServerSessions < ActiveRecord::Migration
  def change
    change_table :server_sessions do |t|
      t.inet :ip
      t.integer :port
    end
  end
end
