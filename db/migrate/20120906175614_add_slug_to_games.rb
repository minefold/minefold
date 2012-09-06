class AddSlugToGames < ActiveRecord::Migration
  def change
    add_column :games, :slug, :string, default: ''
  end
end
