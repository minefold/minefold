class AddBoltAllocationsToFunpacks < ActiveRecord::Migration
  def up
    add_column :funpacks, :bolt_allocations, :integer, :array => true, :default => [512, 1024, 2048]
  end

  def down
    remove_column :funpacks, :bolt_allocations
  end
end
