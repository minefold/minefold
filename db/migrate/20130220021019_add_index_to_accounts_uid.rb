class AddIndexToAccountsUid < ActiveRecord::Migration
  def change
    add_index :accounts, [:uid]
  end
end
