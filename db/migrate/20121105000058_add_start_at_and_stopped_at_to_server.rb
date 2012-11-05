class AddStartAtAndStoppedAtToServer < ActiveRecord::Migration
  def change
    add_column :servers, :start_at, :datetime
    add_column :servers, :stopped_at, :datetime
  end
end
