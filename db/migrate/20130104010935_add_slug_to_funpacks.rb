class AddSlugToFunpacks < ActiveRecord::Migration
  def change
    add_column :funpacks, :slug, :string, default: ''
  end
end
