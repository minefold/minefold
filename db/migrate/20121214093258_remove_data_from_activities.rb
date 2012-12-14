class RemoveDataFromActivities < ActiveRecord::Migration

  def change
    remove_column :activities, :data
  end

end
