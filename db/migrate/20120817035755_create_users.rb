class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username, :default => ''
      t.string   :slug, :default => ''

      t.string   :email
      t.string   :encrypted_password, :default => '', :null => false

      t.string   :facebook_uid

      t.boolean  :admin, :default => false, :null => false
      t.boolean  :unlimited, :default => false, :null => false

      t.string   :first_name
      t.string   :last_name

      t.string   :locale
      t.integer  :timezone, :default => 0
      t.string   :gender

      t.integer  :cr, :default => 0, :null => false
      t.string   :customer_id


      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at

      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      t.string   :authentication_token

      t.timestamps
    end

    add_index :users, :username, :unique => true
    add_index :users, :slug, :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :facebook_uid, :unique => true

    add_index :users, :authentication_token, :unique => true
    add_index :users, :confirmation_token, :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
