class ChangeHostIndexToBeNotUnique < ActiveRecord::Migration
  def change
    remove_index :servers, [:deleted_at, :host]
    add_index :servers, [:deleted_at, :host, :port]
  end

  def down
  end
end
