class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  BILLING_PERIOD = 1.minute
  FREE_HOURS  = 10

  REFERRAL_CODE_LENGTH = 6
  REFERRAL_HOURS = 2

  field :email, type: String

  field :username, type: String
  validates_presence_of :username
  slug  :username, index: true

  field :safe_username, type: String, unique: true
  validates_uniqueness_of :safe_username, case_sensitive: false
  validates_length_of :safe_username, within: 1..16

  field :admin, type: Boolean, default: false

  field :host,           default: 'pluto.minefold.com'

  field :unlimited,      type: Boolean, default: false

  field :credits,        type: Integer, default: (FREE_HOURS.hours / BILLING_PERIOD)
  field :minutes_played, type: Integer, default: 0

  # attr_accessor :stripe_token
  # field :stripe_id,               type: String
  # embeds_one :card

  field :referral_code,   type: String, default: -> {
    self.class.free_referral_code
  }

  validates_uniqueness_of :referral_code

  belongs_to :referrer,  class_name: 'User', inverse_of: :referrals
  has_many   :referrals, class_name: 'User', inverse_of: :referrer


  belongs_to :current_world, class_name: 'World', inverse_of: nil
  has_many :created_worlds, class_name: 'World', inverse_of: :creator

  # has_and_belongs_to_many :opped_worlds,
  #                         inverse_of: :ops,
  #                         class_name: 'World'

  attr_accessor :email_or_username


  scope :potential_members, ->(world) {
    not_in(_id: world.memberships.map {|p| p.user_id})
  }



# Finders

  index :email, unique: true
  scope :by_email, ->(email) {
    where(email: sanitize_email(email))
  }

  index :safe_username, unique: true
  scope :by_username, ->(username) {
    where(safe_username: sanitize_username(username))
  }
  scope :by_email_or_username, ->(str) {
    any_of(
      {safe_username: sanitize_username(str)},
      {email: sanitize_email(str)}
    )
  }


# Validations


  validates_numericality_of :credits
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0


# Security

  attr_accessible :email,
                  :username,
                  :plan_id,
                  :password,
                  :password_confirmation

  attr_accessible :stripe_token,
                  :email_or_username,
                  :remember_me


# Credits

  # Kicks off the audit trail for any credits the user starts off with
  after_create do
    CreditTrail.log(self, self.credits)
  end

  def customer_description
    [safe_username, id].join('-')
  end

  def create_charge!(stripe_token, pack)
    Stripe::Charge.create(
      card: stripe_token,
      amount: pack.amount,
      currency: 'usd',
      description: "#{customer_description}: #{pack.hours}h"
    )
  rescue StripeError
    false
  end

  def buy_time!(stripe_token, pack)
    create_charge!(stripe_token, pack) and increment_hours!(pack.hours)
  end

  def increment_hours!(n)
    increment_credits! self.class.hours_to_credits(n)
  end

  def increment_credits!(n)
    inc(:credits, n.to_i).tap { CreditTrail.log(self, n.to_i)}
  end

  def hours_left
    credits / User::BILLING_PERIOD
  end


# Authentication

  devise :registerable,
         :database_authenticatable,
         :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  def username=(str)
    super(str)
    self.safe_username = self.class.sanitize_username(str)
  end


# Avatars

  mount_uploader :avatar, AvatarUploader

  def fetch_avatar!
    self.remote_avatar_url = "http://minecraft.net/skin/#{safe_username}.png"
    # Minecraft doesn't store default skins so it raises a HTTPError
  rescue OpenURI::HTTPError
  end

  def async_fetch_avatar!
    Resque.enqueue(FetchAvatarJob, id)
  end

  before_save do
    async_fetch_avatar! if safe_username_changed?
  end


# Referrals

  def self.free_referral_code
    begin
      c = rand(36 ** REFERRAL_CODE_LENGTH).to_s(36)
    end while self.where(referral_code: c).exists?
    c
  end

  def played?
    true
  end

# Mail throttling
  # TODO Move to the top

  field :last_world_started_mail_sent_at

  def member?(world)
    world.memberships.any? {|m| m.user == self}
  end

  def op?(world)
    world.memberships.any? {|m| m.user == self && m.role == Memberships::OP}
  end

# Other

  def self.paid_for_minecraft?(username)
    response = RestClient.get "http://www.minecraft.net/haspaid.jsp", params: {user: username}
    return response == 'true'
  rescue RestClient::Exception
    return false
  end

  def worlds
    World.where('memberships.user_id' => id).sort_by do |world|
      world.name.downcase
    end
  end

  def current_world?(world)
    current_world == world
  end

  def to_param
    slug
  end

  # Security. When searching for potential players in a world the results were returning emails and credit cards of users.
  def as_json(options={})
    {
      id: id,
      username: safe_username,
      avatar: avatar.head.as_json
    }
  end

protected

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:email_or_username)
    by_email_or_username(login).first
  end

  def self.chris
    where(username: 'chrislloyd').cache.first
  end

  def self.dave
    where(username: 'whatupdave').cache.first
  end

  def self.sanitize_username(str)
    str.downcase.strip
  end

  private

  def self.sanitize_email(str)
    str.downcase.strip
  end

  def self.hours_to_credits(n)
    n.hours / BILLING_PERIOD
  end

end
