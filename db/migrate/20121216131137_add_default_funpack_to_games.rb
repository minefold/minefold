class AddDefaultFunpackToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.references :default_funpack
    end
  end
end
