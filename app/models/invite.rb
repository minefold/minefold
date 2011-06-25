class Invite
  include MongoMapper::Document

  TOKEN_LENGTH = 6

  key :token,   String,  :unique => true,
                         :length => 0..TOKEN_LENGTH
  key :user_id, ObjectId
  timestamps!



  ensure_index :token, :unique => true

  before_validation :generate_token, :on => :create

  scope :unclaimed, :user_id => nil

  belongs_to :user

private

  def generate_token
    begin
      self.token = self.class.random_token
    end until self.class.first(:token => self.token).nil?
  end

  def self.random_token(length=TOKEN_LENGTH)
    rand(36 ** length).to_s(36).upcase
  end
end
