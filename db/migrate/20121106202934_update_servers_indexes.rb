class UpdateServersIndexes < ActiveRecord::Migration

  def up
    remove_index :servers, :host
    add_index :servers, [:deleted_at, :host], unique: true
  end

  def down
    remove_index :servers, [:deleted_at, :host]
    add_index :servers, :host, unique: true
  end

end
