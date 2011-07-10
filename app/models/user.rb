class User
  include MongoMapper::Document

  class Unauthenticated < StandardError; end

  key :email,              String, unique: true
  key :username,           String, unique: true
  key :encrypted_password, String, length: 0..128
  key :credits,            Integer, default: 0
  key :world_id,           ObjectId
  timestamps!

  belongs_to :world,       class: World

  ensure_index :username, unique: true

  before_validation :normalize_email

  def normalize_email
    email.try(:downcase!).try(:strip!)
  end

  def add_credits n
    increment credits: n
  end

  def hours
    credits.minutes / 1.hour
  end
  alias_method :hour, :hours



# Authentication

  STRETCHES = 10

  attr_accessor :password_confirmation

  validates_confirmation_of :password, :if => :password

  # TODO: Implement a constant-time comparison to prevent timing attacks
  #       (see Devise.secure_compare).
  def password
    @password ||= if encrypted_password?
      BCrypt::Password.new(encrypted_password)
    else
      nil
    end
  end

  # TODO: Implement peppers
  def password=(new_password)
    self.encrypted_password = @password =
      BCrypt::Password.create(new_password, cost: STRETCHES)
      # BCrypt::Password.create([new_password, ENV['PEPPER']].join, cost: STRETCHES)
  end

  # TODO: Change Warden to use this abstraction (to help implementing peppers)
  def check_password?(pw)
    password == pw
  end

end
