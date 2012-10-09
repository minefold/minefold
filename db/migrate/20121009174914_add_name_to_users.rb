class AddNameToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name, default: ''
    end
  end
end
