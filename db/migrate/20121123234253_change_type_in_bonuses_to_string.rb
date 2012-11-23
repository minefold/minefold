class ChangeTypeInBonusesToString < ActiveRecord::Migration

  def change
    change_column :bonuses, :type, :string, null: false
  end

end
