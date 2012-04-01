class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Timestamps
  include Mongoid::Paranoia


  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :minecraft_player


# --
# Indexes





# ---
# Minecraft Account


  VERIFICATION_TOKEN_LENGTH = 6

  def self.verification_token_exists?(token)
    where(verification_token: token).exists?
  end

  def self.free_verification_token
    begin
      token = rand(36 ** VERIFICATION_TOKEN_LENGTH).to_s(36)
    end while verification_token_exists?(token)
    token
  end


  has_one :minecraft_player, dependent: :nullify
  default_scope includes(:minecraft_player)
  accepts_nested_attributes_for :minecraft_player

  def verified?
    !!minecraft_player
  end

  field :verification_token, type: String, default: ->{
    self.class.free_verification_token
  }
  validates_uniqueness_of :verification_token

  def verification_host
    "#{verification_token}.verify.minefold.com"
  end


# ---
# Identity


  def username
    minecraft_player and minecraft_player.username
  end


# ---
# Flags


  field :admin, type: Boolean, default: false
  field :beta, type: Boolean, default: false


# ---
# Authentication


  devise :registerable,
         :database_authenticatable,
         :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :token_authenticatable,
         :omniauthable

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

  attr_accessor :email_or_username

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:email_or_username)

    if user = by_email(login).first
      user
    elsif player = MinecraftPlayer.by_username(login).where(:user_id.ne => nil).first
      player.user
    else
      false
    end
  end


# ---
# Email


  field :email, type: String, null: true
  scope :by_email, ->(email) { where(email: sanitize_email(email)) }

  def self.sanitize_email(str)
    str.downcase.strip
  end


# ---
# OAuth


  field :facebook_uid, type: String, null: true

  def facebook_linked?
    not facebook_uid.nil?
  end


  def self.find_or_create_for_facebook_oauth(access_token, signed_in_user=nil, email=nil)
    uid, data = access_token.uid, access_token.extra.raw_info
    email = data.email || email

    begin
      case
      when signed_in_user
        signed_in_user.facebook_uid = uid
        signed_in_user.save!
        signed_in_user

      when user = where(facebook_uid: uid).first
        user
      when user = where(email: email).first
        user.facebook_uid = uid
        user.email = email if email
        user.save!
        user
      else
        # Create a user with a stub password.
        user = new(
          email: email,
          password: Devise.friendly_token[0,20])

        user.skip_confirmation!
        user.facebook_uid = uid
        user.save!
        user
      end
    rescue => e
      raise "#{access_token.inspect}\n#{e}\n#{e.backtrace}"
    end
  end


# ---
# Credits


  BILLING_PERIOD = 1.minute
  FREE_HOURS = 10

  def self.hours_to_credits(n)
    n.hours / BILLING_PERIOD
  end

  FREE_CREDITS = hours_to_credits(FREE_HOURS)


  field :credits, type: Integer, default: FREE_CREDITS
  field :last_credit_refresh_at, type: DateTime

  def increment_credits!(n)
    inc(:credits, n.to_i)
  end

  def increment_hours!(n)
    increment_credits! self.class.hours_to_credits(n)
  end

  def hours_left
    credits / BILLING_PERIOD
  end


# ---
# Billing


  field :plan_expires_at, type: DateTime

  def pro?
    (not plan_expires_at.nil? and plan_expires_at.future?) or beta?
  end

  def extend_plan_by(time)
    if plan_expires_at?
      self.plan_expires_at += time
    else
      self.plan_expires_at = time.from_now
    end
  end

  def create_charge!(stripe_token, pack)
    Stripe::Charge.create(
      card: stripe_token,
      amount: pack.cents,
      currency: 'usd',
      description: "User##{id} #{pack.id}"
    )
  end

  def buy_pack!(stripe_token, pack)
    create_charge!(stripe_token, pack) and
    extend_plan_by(pack.months.months) and
    save!
  end


# ---
# Settings


  field :notifications, type: Hash, default: ->{ Hash.new }
  attr_accessible :notifications

  field :last_world_started_mail_sent_at, type: DateTime

  def notify?(notification)
    confirmed? and notifications[notification.to_s] != "0"
  end


# ---
# Invites


  INVITE_TOKEN_LENGTH = 6

  def self.invite_token_exists?(token)
    where(invite_token: token).exists?
  end

  def self.free_invite_token
    begin
      token = rand(36 ** INVITE_TOKEN_LENGTH).to_s(36)
    end while invite_token_exists?(token)
    token
  end

  field :invite_token, type: String, default: ->{
    self.class.free_invite_token
  }
  validates_uniqueness_of :invite_token


  belongs_to :referrer, class_name: 'User', inverse_of: :referrals
  has_many :referrals, class_name: 'User', inverse_of: :referrer


# ---
# Worlds


  has_many :created_worlds, class_name: 'World', inverse_of: :creator

  belongs_to :current_world, class_name: 'World', inverse_of: nil

  def member?(world)
    world.memberships.any? {|m| m.user == self}
  end

  def op?(world)
    world.memberships.any? {|m| m.user == self && m.role == Memberships::OP}
  end

  def current_world?(world)
    current_world == world
  end

  def cloned?(world)
    created_worlds.where(parent_id: world.id).exists?
  end


# ---
# Photos


  # has_many :photos, inverse_of: :creator, order: [:created_at, :asc]
  # accepts_nested_attributes_for :photos

  # def pending_photos
  #   photos.pending
  # end

  # def published_photos
  #   photos.published
  # end
  # accepts_nested_attributes_for :pending_photos



# ---
# Messaging


  def private_channel_key
    "private-#{self.class.name.downcase}-#{id}"
  end

  def private_channel
    Pusher[private_channel_key]
  end


# ---
# Stats


  def self.mpid
    @uuid ||= UUID.new
    @uuid.generate
  end

  field :mpid, type: String, default: ->{ self.mpid.to_s }
  alias_method :distinct_id, :mpid


protected

  def self.chris
    where(username: 'chrislloyd').cache.first
  end

  def self.dave
    where(username: 'whatupdave').cache.first
  end

end
