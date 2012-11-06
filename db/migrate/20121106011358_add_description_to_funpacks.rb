class AddDescriptionToFunpacks < ActiveRecord::Migration
  def change
    add_column :funpacks, :description, :text
    add_column :funpacks, :info_url, :string
  end
end
