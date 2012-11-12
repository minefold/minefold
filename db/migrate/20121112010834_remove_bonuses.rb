class RemoveBonuses < ActiveRecord::Migration
  def change
    drop_table :bonuses
    rename_column :bonus_claims, :bonus_id, :bonus_type

    add_index :bonus_claims, [:bonus_type, :user_id]
    add_index :bonus_claims, [:bonus_type]
  end
end
