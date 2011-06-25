class User
  include MongoMapper::Document
  extend Devise::Models
  include Gravtastic

  devise :database_authenticatable

  gravtastic :secure => true, :rating => 'G'


  # Schema

  key :email, String, unique: true
  key :username, String, unique: true
  key :encrypted_password, String, length: 0..128

  key :active_world, World

  key :invite_id, ObjectId

  timestamps!

  ensure_index :username

  validates_confirmation_of :password
  validates_presence_of :invite_id

  before_create :claim_invite

  def claim_invite
    invite = Invite.find(invite_id)
    invite.user_id = self.id
    invite.save
  end

end
