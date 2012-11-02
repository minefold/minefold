class AddMoreLegacyFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legacy_id, :string
    add_column :users, :deleted_at, :datetime
    
    add_column :servers, :deleted_at, :datetime
  end
end
