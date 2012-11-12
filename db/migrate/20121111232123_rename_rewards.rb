class RenameRewards < ActiveRecord::Migration
  def change
    rename_table :rewards, :bonuses
    rename_table :reward_claims, :bonus_claims

    rename_column :bonus_claims, :reward_id, :bonus_id

    add_column :bonuses, :hidden, :boolean, default: false
    add_column :bonuses, :claim_limit, :integer, default: 1
  end
end
