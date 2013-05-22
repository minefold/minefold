class CreateShots < ActiveRecord::Migration

  def change
    create_table :shots do |t|
      t.references :uploader, :null => false
      t.references :server
      t.string :file, :null => false
      t.timestamps
    end
  end

end
