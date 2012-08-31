class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :game
      t.references :user
      t.string :uid

      t.timestamps
    end

    add_index :players, :game_id
    add_index :players, :user_id
  end
end
