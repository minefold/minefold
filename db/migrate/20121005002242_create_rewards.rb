class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.string :name
      t.integer :credits

      t.timestamps
    end
    
    create_table :reward_claims do |t|
      t.references :reward, null: false
      t.references :user, null: false
      
      t.timestamps
    end
    
    add_index :reward_claims, [:reward_id, :user_id], unique: true
    
  end
end
