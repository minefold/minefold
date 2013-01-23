class AddCnameToServers < ActiveRecord::Migration
  def change
    add_column :servers, :cname, :string
  end
end
