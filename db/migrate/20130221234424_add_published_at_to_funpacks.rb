class AddPublishedAtToFunpacks < ActiveRecord::Migration
  def change
    change_table :funpacks do |t|
      t.datetime :published_at
    end
  end
end
