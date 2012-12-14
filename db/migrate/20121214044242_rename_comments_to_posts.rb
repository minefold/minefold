class RenameCommentsToPosts < ActiveRecord::Migration

  def change
    rename_table :comments, :posts

    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.references :author
      t.text :body

      t.timestamps
    end
  end

end
