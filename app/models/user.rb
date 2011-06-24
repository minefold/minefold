class User
  include MongoMapper::Document
  extend Devise::Models
  include Gravtastic

  devise :database_authenticatable

  gravtastic :secure => true, :rating => 'G'


  # Schema

  key :email,              String, unique: true
  key :username,           String, unique: true
  key :encrypted_password, String, length: 0..128

  key :active_world,       World

  timestamps!

  ensure_index :username

  validates_confirmation_of :password
end
