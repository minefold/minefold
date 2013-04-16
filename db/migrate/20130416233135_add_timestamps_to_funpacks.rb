class AddTimestampsToFunpacks < ActiveRecord::Migration
  def change
    change_table :funpacks do |t|
      t.timestamps
    end
  end
end
