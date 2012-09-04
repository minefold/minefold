class CreateFunpacks < ActiveRecord::Migration
  def change
    create_table :funpacks do |t|
      t.string :name
      t.references :game
      t.references :creator
    end

    add_index :funpacks, :game_id

  end
end
