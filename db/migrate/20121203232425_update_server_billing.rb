class UpdateServerBilling < ActiveRecord::Migration
  def change
    remove_column :games, :shared_servers
    remove_column :games, :persistant

    add_column :games, :auth, :boolean, null: false, default: false
    add_column :games, :routing, :boolean, null: false, default: false
    add_column :games, :maps, :boolean, null: false, default: false

    change_column :servers, :shared, :boolean, null: false, default: true
  end
end
