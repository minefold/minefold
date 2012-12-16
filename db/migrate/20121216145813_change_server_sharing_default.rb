class ChangeServerSharingDefault < ActiveRecord::Migration

  def change
    change_column :servers, :shared, :boolean, default: false, null: false
  end

end
