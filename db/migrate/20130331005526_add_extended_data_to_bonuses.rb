class AddExtendedDataToBonuses < ActiveRecord::Migration
  def change
    change_table :bonuses do |t|
      t.integer :state
      t.hstore :data
      t.datetime :updated_at
    end
    
    Bonus.connection.execute("update bonuses set updated_at=created_at")
    
    change_column :bonuses, :updated_at, :datetime, null: false
  end
end
