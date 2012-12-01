class AddMapQueuedAtToWorld < ActiveRecord::Migration
  def change
    add_column :worlds, :map_queued_at, :datetime
  end
end
