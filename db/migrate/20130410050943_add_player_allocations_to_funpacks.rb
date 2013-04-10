class AddPlayerAllocationsToFunpacks < ActiveRecord::Migration
  def up
    add_column :funpacks, :player_allocations, :integer, :array => true, :default => [10, 25, 50]
  end

  def down
    remove_column :funpacks, :player_allocations
  end
end
