class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  BILLING_PERIOD = 1.minute
  FREE_HOURS  = 10

  REFERRAL_CODE_LENGTH = 6
  REFERRAL_HOURS = 2


  field :email, type: String, null: true
  field :username,       type: String
  field :safe_username,  type: String
  slug  :username,       index: true

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
  has_many :worlds, :foreign_key => 'memberships.user_id'

  has_and_belongs_to_many :opped_worlds,
                          inverse_of: :ops,
                          class_name: 'World'

  attr_accessor :email_or_username


# Finders

  index :email, unique: true
  scope :by_email, ->(email) {
    where(email: sanitize_email(email))
  }

  field :username, type: String
  slug :username, index: true
  validates_length_of :safe_username, within: 1..16, allow_nil: true
  validate :reserved_usernames

  field :safe_username, type: String
  validates_uniqueness_of :safe_username, case_sensitive: false, allow_nil: true
  validates_length_of :safe_username, within: 1..16, allow_nil: true
  index :safe_username

  def username=(str)
    super(str.strip)
    self.safe_username = self.class.sanitize_username(str)
  end

  scope :by_username, ->(username) {
    where(safe_username: sanitize_username(username))
  }

  attr_accessor :email_or_username
  scope :by_email_or_username, ->(str) {
    any_of(
      {safe_username: sanitize_username(str)},
      {email: sanitize_email(str)}
    )
  }

# Devise fields

  field :encrypted_password, type: String, null: true

  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  field :remember_created_at, type: Time

  field :sign_in_count, type: Integer
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  field :confirmation_token, type: String
  field :confirmed_at, type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email, type: String # Only if using reconfirmable

  field :authentication_token, type: String
  index :authentication_token, unique: true

  devise :registerable,
         :database_authenticatable,
         :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :token_authenticatable,
         :omniauthable


  field :mpid, type: String, default: ->{ self.id.to_s }
  attr_accessible :mpid

  # OAuth

  field :facebook_uid, type: String
  index :facebook_uid, unique: true

  def self.find_or_create_for_facebook_oauth(access_token, signed_in_resource=nil)
    uid, data = access_token.uid, access_token.extra.raw_info
    email = data.email

    if user = User.where(facebook_uid: uid).first
      user
    elsif user = User.where(email: email).first
      user.facebook_uid = uid
      user.save!
      user
    else
      # Create a user with a stub password.
      user = User.create!(email: email, facebook_uid: uid, password: Devise.friendly_token[0,20])
      user.confirm!
      user
    end
  end

  field :admin, type: Boolean, default: false

  field :host, default: 'pluto.minefold.com'

  # Feature flags

  field :beta, type: Boolean, default: false
  field :features, type: Array

  def feature?(feature)
    features.include? feature
  end

  field :plan_expires_at, type: DateTime

  def pro?
    beta? or (not plan_expires_at.nil? and plan_expires_at.future?)
  end

  field :credits, type: Integer, default: (FREE_HOURS.hours / BILLING_PERIOD)
  validates_numericality_of :credits

  field :last_credit_reset, type: DateTime

  field :minutes_played, type: Integer, default: 0
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0

  field :last_played_at, type: DateTime

  def played?
    not last_played_at.nil?
  end

  has_many :photos, inverse_of: :creator, order: [:created_at, :asc]
  accepts_nested_attributes_for :photos

  def pending_photos
    photos.pending
  end

  def published_photos
    photos.published
  end

  accepts_nested_attributes_for :pending_photos

  field :notifications, type: Hash, default: ->{ Hash.new }
  field :last_world_started_mail_sent_at, type: DateTime

  field :referral_code, type: String, default: ->{ self.class.free_referral_code }
  validates_uniqueness_of :referral_code

  belongs_to :referrer, class_name: 'User', inverse_of: :referrals
  has_many :referrals, class_name: 'User', inverse_of: :referrer


  belongs_to :current_world, class_name: 'World', inverse_of: nil
  has_many :created_worlds, class_name: 'World', inverse_of: :creator

  scope :potential_members_for, ->(world) {
    not_in(_id: world.memberships.map {|p| p.user_id})
  }

  def events
    Event.where(source_id: self.id).order_by([:created_at, :desc]).limit(40)
  end


  # Security

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation,
                  :notifications

  attr_accessible :stripe_token,
                  :email_or_username,
                  :remember_me

# Validations

  def reserved_usernames
    if UsernameBlacklist.include? safe_username
      errors.add :username, 'is reserved'
    end
  end

# Credits

  def customer_description
    [safe_username, id].join('-')
  end

  def create_charge!(stripe_token, pack)
    Stripe::Charge.create(
      card: stripe_token,
      amount: pack.cents,
      currency: 'usd',
      description: "#{pack.months} months of Minefold Pro for #{username} (#{email})"
    )
  rescue Stripe::StripeError
    false
  end

  def buy_pack!(stripe_token, pack)
    create_charge!(stripe_token, pack) and extend_plan_expiry!(pack.months)
  end

  def extend_plan_expiry!(months)
    current_expiry = plan_expires_at || Time.now
    self.plan_expires_at = current_expiry + months.months
    save!
  end

  def increment_hours!(n)
    increment_credits! self.class.hours_to_credits(n)
  end

  def increment_credits!(n)
    inc(:credits, n.to_i)
  end

  def hours_left
    credits / User::BILLING_PERIOD
  end


# Avatars

  mount_uploader :avatar, AvatarUploader

  def fetch_avatar!
    self.remote_avatar_url = "http://minecraft.net/skin/#{safe_username}.png"
    # Minecraft doesn't store default skins so it raises a HTTPError
  rescue OpenURI::HTTPError
  end

  def cloned?(world)
    created_worlds.where(parent_id: world.id).exists?
  end

# Referrals

  def self.free_referral_code
    begin
      c = rand(36 ** REFERRAL_CODE_LENGTH).to_s(36)
    end while self.where(referral_code: c).exists?
    c
  end

  def member?(world)
    world.memberships.any? {|m| m.user == self}
  end

  def op?(world)
    world.memberships.any? {|m| m.user == self && m.role == Memberships::OP}
  end

# Notifications

  def notify? notification
    notifications[notification.to_s] != "0"
  end

# Other

  def current_world?(world)
    current_world == world
  end

  def to_param
    slug
  end


  def stream
    $redis.lrange("users/#{id}/stream", 0, 100)
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
