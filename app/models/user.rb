class User
  include MongoMapper::Document
  include Gravtastic

  BILLING_PERIOD = 1.minute
  MAX_REFERRALS  = 10
  FREE_HOURS  = 1

  key :email,    String,  unique: true
  key :username, String
  key :credits,  Integer, default: (FREE_HOURS.hours / BILLING_PERIOD)
  key :minutes_played,  Integer, default: 0
  key :last_played_at, Time

  key :referrals, Integer, :default => 0

  one :invite

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

  gravtastic format: :png

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation,
                  :invite_code

  # TODO: Should really be in MongoMapper
  def worlds
    World.all(player_ids: id)
  end

  before_create do
    self.world = World.default
  end

  def first_signin?
    sign_in_count <= 1
  end

  def verified?
    not last_played_at.nil?
  end


# Credits

  def add_credits n
    increment credits: (n / BILLING_PERIOD)
  end

  def hours
    (credits * BILLING_PERIOD) / 1.hour
  end

  def minutes
    credits - (hours * (1.hour / BILLING_PERIOD))
  end

# Invites

  def free_invites?
    invites > 0
  end

  def invite_code=(code)
    self.invite = Invite.unclaimed.find_by_code(code.downcase)
  end

  def referrals_left
    MAX_REFERRALS - referrals
  end

  after_create do
    self.invite.user = self
    self.invite.save
  end

  USER_REFERRAL_BONUS = 1.hour
  FRIEND_REFERRAL_BONUS = 4.hours

  def verify!
    decrement referrals: 1
    invite.set claimed: true

    add_credits USER_REFERRAL_BONUS
    invite.creator.add_credits FRIEND_REFERRAL_BONUS
  end

  validates_presence_of :invite, on: :create

protected

  def self.chris
    find_by_email 'chris@minefold.com'
  end

  def self.dave
    find_by_email 'dave@minefold.com'
  end

end
