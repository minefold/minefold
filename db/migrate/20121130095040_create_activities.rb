class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :type, null: false
      t.references :actor, polymorphic: true
      t.references :subject, polymorphic: true
      t.references :target, polymorphic: true
      t.timestamps
    end
  end
end
