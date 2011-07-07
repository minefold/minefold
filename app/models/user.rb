class User
  include MongoMapper::Document

  key :email, String
  key :username, String
  key :encrypted_password, String, :length => 0..128
  key :world_id, ObjectId
  timestamps!

  belongs_to :world, :class => World

  ensure_index :username, :unique => true
  ensure_index :invite,   :unique => true

  validates_uniqueness_of :email, :allow_nil => true
  validates_uniqueness_of :username, :allow_nil => true

  before_validation { self.email.try :downcase!}
  before_validation { self.email.try :strip!}

# Authentication

  STRETCHES = 10

  # TODO: Implement a constant-time comparison to prevent timing attacks
  #       (see Devise.secure_compare).
  def password
    @password ||= if encrypted_password?
      BCrypt::Password.new(encrypted_password)
    else
      nil
    end
  end

  def password= new_password
    self.encrypted_password = @password =
      BCrypt::Password.create(new_password, cost: STRETCHES)
      # BCrypt::Password.create([new_password, ENV['PEPPER']].join, cost: STRETCHES)
  end

  attr_accessor :password_confirmation
  validates_confirmation_of :password, :if => :password
end
