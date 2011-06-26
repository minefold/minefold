class User
  include MongoMapper::Document
  extend Devise::Models
  include Gravtastic

  TOKEN_LENGTH = 6

  devise :database_authenticatable

  gravtastic :secure => true, :rating => 'G'


  # Schema

  key :email, String
  key :username, String
  key :encrypted_password, String, :length => 0..128
  key :active_world, World
  timestamps!

  key :invite, String

  ensure_index :username, :unique => true
  ensure_index :invite, :unique => true

  validates_uniqueness_of :email, :allow_nil => true
  validates_uniqueness_of :username, :allow_nil => true

  validates_presence_of :invite
  validates_uniqueness_of :invite

  validates_confirmation_of :password


  before_validation :generate_invite, :on => :create

  def generate_invite
    begin
      self.invite = self.class.random_token
    end while self.class.exist?(:invite => invite)
  end

private

  def self.random_token(length=TOKEN_LENGTH)
    SecureRandom.random_number(36 ** length).to_s(36).upcase
  end

end
