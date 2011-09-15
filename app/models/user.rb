class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia
  include Gravtastic


  BILLING_PERIOD = 1.minute
  FREE_HOURS     = 1

  field :email,          type: String
  field :username,       type: String
  field :safe_username,  type: String
  slug  :username,       index: true

  field :host, default: 'pluto.minefold.com'

  field :staff,          type: Boolean, default: false

  field :credits,        type: Integer, default: 0
  field :minutes_played, type: Integer, default: 0
  embeds_many :credit_events

  has_many :orders

  belongs_to :current_world, class_name: 'World'
  has_many :created_worlds, class_name: 'World', inverse_of: :creator
  has_and_belongs_to_many :worlds

  embeds_many :wall_items, as: :wall

  field :total_referrals, type: Integer, default: 10
  embeds_many :referrals
  belongs_to  :referrer, class_name: 'User', inverse_of: :user

  attr_accessor :email_or_username


# VALIDATIONS

  validates_presence_of :username
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_confirmation_of :password
  validates_numericality_of :credits, greater_than_or_equal_to: 0
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0
  validates_numericality_of :total_referrals, greater_than_or_equal_to: 0

# SECURITY

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation

  # Virtual
  attr_accessible :email_or_username,
                  :remember_me


# SIGNUPS

  SPOTS = 100

  def self.free_spots
    SPOTS - count
  end

  def self.free_spots?
    free_spots > 0
  end

  before_validation on: :create do
    self.current_world = World.default
  end


# CREDITS

  scope :free, where(:orders.size => 0)

  # Gives away the free credits and starts off the credit history
  after_create do
    increment_credits! FREE_HOURS.hours / BILLING_PERIOD
  end

  def increment_credits!(n, time=Time.now.utc)
    event = CreditEvent.new(delta: n)

    self.class.collection.update({_id: id}, {
      '$inc' => {
        credits: n
      },
      '$push' => {
        credit_events: event.attributes.merge(
          created_at: time
        )
      }
    })
  end

  def hours
    (credits * BILLING_PERIOD) / 1.hour
  end

  def minutes
    credits - (hours * (1.hour / BILLING_PERIOD))
  end


# AUTHENTICATION

  devise :registerable,
         :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  def first_sign_in?
    sign_in_count <= 1
  end

  def username=(str)
    super(str)
    self.safe_username = self.class.sanitize_username(str)
  end

# AVATARS

  gravtastic format: :png


# REFERRALS

  USER_REFERRAL_BONUS = 1.hour
  FRIEND_REFERRAL_BONUS = 4.hours

  def referrals_left?
    referrals.length < total_referrals
  end

  def referrals_left
    total_referrals - referrals.length
  end

#   def verify!
#     decrement referrals: 1
#     invite.set claimed: true
#
#     add_credits USER_REFERRAL_BONUS
#     invite.creator.add_credits FRIEND_REFERRAL_BONUS
#   end

  def to_param
    slug
  end

protected

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:email_or_username)
    any_of({safe_username: sanitize_username(login)}, {email: login}).first
  end

  def self.chris
    where(username: 'chrislloyd').cache.first
  end

  def self.dave
    where(username: 'whatupdave').cache.first
  end

private

  def self.sanitize_username(str)
    str.downcase
  end

end
