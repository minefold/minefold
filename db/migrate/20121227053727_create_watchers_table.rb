class CreateWatchersTable < ActiveRecord::Migration

  def change
    create_table :servers_users, id: false do |t|
      t.references :user
      t.references :server
    end
  end

end
