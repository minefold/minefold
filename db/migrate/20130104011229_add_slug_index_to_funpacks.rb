class AddSlugIndexToFunpacks < ActiveRecord::Migration
  def up
    Funpack.find_each(&:save)
    
    add_index :funpacks, :slug, unique: true
  end
  
  def down
    remove_index :funpacks, :slug
  end
end
