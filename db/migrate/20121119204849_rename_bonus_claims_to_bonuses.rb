class RenameBonusClaimsToBonuses < ActiveRecord::Migration

  def change
    rename_table :bonus_claims, :bonuses
    rename_column :bonuses, :bonus_type, :type
    remove_column :bonuses, :updated_at
  end

end
