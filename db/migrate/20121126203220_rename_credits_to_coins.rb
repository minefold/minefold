class RenameCreditsToCoins < ActiveRecord::Migration

  def change
    rename_column :bonuses, :credits, :coins

    rename_column :credit_packs, :credits, :coins
    rename_table :credit_packs, :coin_packs

    rename_column :users, :credits, :coins
    rename_column :users, :last_credit_fairy_visit_at, :last_coin_fairy_visit_at
  end

end
