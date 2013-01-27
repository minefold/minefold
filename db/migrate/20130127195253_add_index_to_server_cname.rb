class AddIndexToServerCname < ActiveRecord::Migration
  def change
    add_index :servers, [:cname, :deleted_at]
  end
end
