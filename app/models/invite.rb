class Invite
  include MongoMapper::Document

  TOKEN_LENGTH = 6

  key :token,   String,  :unique => true,
                         :length => 0..TOKEN_LENGTH
  belongs_to :user
  timestamps!


  ensure_index :token, :unique => true

  before_validation :generate_token, :on => :create

  scope :unclaimed, :user_id => nil

private

  def generate_token
    begin
      self.token = self.class.random_token
    end while self.class.exist?(:token => self.token)
  end

  def self.random_token(length=TOKEN_LENGTH)
    SecureRandom.random_number(36 ** length).to_s(36).upcase
  end
end
