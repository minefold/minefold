class RemoveUnlimitedFromUsers < ActiveRecord::Migration
  
  def change
    remove_column :users, :unlimited
  end
  
end
