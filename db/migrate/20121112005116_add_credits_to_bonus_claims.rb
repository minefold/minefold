class AddCreditsToBonusClaims < ActiveRecord::Migration
  def change
    add_column :bonus_claims, :credits, :integer
  end
end
