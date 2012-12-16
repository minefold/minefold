class AddImportsFlagToFunpacks < ActiveRecord::Migration
  def change
    add_column :funpacks, :imports, :boolean, default: false
  end
end
