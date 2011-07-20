class User
  include MongoMapper::Document
  include Gravtastic


  CREDIT_UNITS = 1.minute

  key :email,    String,  unique: true
  key :username, String
  key :special,  Boolean, default: true
  key :credits,  Integer, default: (1.hour / CREDIT_UNITS)
  many :wall_items, as: :wall
  belongs_to :world
  timestamps!

  validates_uniqueness_of :username, allow_nil: true

  devise :registerable,
         :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  gravtastic secure: true,
             format: :png,
             default: 'identicon'

  attr_accessible :email, :username, :password, :password_confirmation

  # Credits

  def increment_credits n
    increment credits: (n.hours / CREDIT_UNITS)
    n
  end

  def format_credits
    (credits * CREDIT_UNITS) / 1.hour
  end


protected

  def password_required?
    false
  end

end
