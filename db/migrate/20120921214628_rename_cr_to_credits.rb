class RenameCrToCredits < ActiveRecord::Migration

  def change
    rename_column :users, :cr, :credits
    rename_column :credit_packs, :cr, :credits
  end

end
