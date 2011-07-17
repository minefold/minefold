class User
  include MongoMapper::Document

  key :email,              String, unique: true
  key :username,           String, unique: true
  key :encrypted_password, String, length: 0..128

  key :special, Boolean, default: false

  key :credits,            Integer, default: 0

  belongs_to :world

  many :wall_items, as: :wall

  timestamps!


  # Normalize email
  before_validation do
    email.try(:downcase!).try(:strip!)
  end


  # Credits
  CREDIT_UNITS = 1.minute

  def credit n
    increment credits: (n / CREDIT_UNITS)
  end

  def hours
    (credits * CREDIT_UNITS) / 1.hour
  end

# Authentication

  class Unauthenticated < StandardError; end

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
