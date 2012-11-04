class AddLegacyParentIdToWorld < ActiveRecord::Migration
  def change
    add_column :worlds, :legacy_parent_id, :integer
  end
end
