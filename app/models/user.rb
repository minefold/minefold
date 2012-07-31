class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Verifiable
  include Referrable

  field :bio, type: String, default: ''
  attr_accessible :bio

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :minecraft_player


# --
# Indexes

  index(
    {deleted_at: 1, invite_token: 1},
    {unique: true}
  )

  index(
    {deleted_at: 1, referrer_id: 1},
    {unique: true}
  )



# ---
# Minecraft Account


  has_one :minecraft_player, dependent: :nullify

  # TODO: this causes a bug with mongoid
  # user.referrals
  # as it adds minecraft_player to a scope which may be nil
  # default_scope includes(:minecraft_player)
  accepts_nested_attributes_for :minecraft_player

  def verified?
    !!minecraft_player
  end

  def verification_host
    "#{verification_token}.verify.minefold.com"
  end


# ---
# Identity


  def username
    minecraft_player and minecraft_player.username
  end

  def slug
    minecraft_player and minecraft_player.slug
  end

  def full_name
    if name.blank? and not first_name.blank? and not last_name.blank?
      [first_name, last_name].join(' ')
    else
      name
    end
  end


# ---
# Flags


  field :admin, type: Boolean, default: false
  field :beta, type: Boolean, default: false

  field :r, type: Integer

  def rollout
    self[:r] || begin
      n = rand(100)
      set :r, n
      n
    end
  end



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

  field :encrypted_password, type: String

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


  field :email, type: String
  scope :by_email, ->(email) { where(email: sanitize_email(email)) }

  def self.sanitize_email(str)
    str.downcase.strip
  end


# ---
# OAuth


  field :facebook_uid, type: String

  attr_accessible :name, :first_name, :last_name

  field :name, type: String
  field :first_name, type: String
  field :last_name, type: String

  def facebook_linked?
    not facebook_uid.nil?
  end


  def self.find_or_create_for_facebook_oauth(access_token, signed_in_user=nil, email=nil)
    uid, data = access_token.uid, access_token.extra.raw_info
    email = data.email || email

    begin
      case
      # User is already signed in
      when signed_in_user
        user.update_attributes!(
          facebook_uid: uid,
          name: data.name,
          first_name: data.first_name,
          last_name: data.last_name
        )
        signed_in_user

      # User exists
      when user = where(facebook_uid: uid).first
        user.update_attributes!(
          name: data.name,
          first_name: data.first_name,
          last_name: data.last_name
        )
        user

      # User exists with the same email
      when user = by_email(email).first
        user.update_attributes!(
          facebook_uid: uid,
          name: data.name,
          first_name: data.first_name,
          last_name: data.last_name
        )
        user

      # No user exists
      else
        user = new(
          email: email,
          name: data.name,
          first_name: data.first_name,
          last_name: data.last_name,
          password: Devise.friendly_token[0,20] # Stub password
        )

        user.facebook_uid = uid
        user.skip_confirmation!

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
  field :last_credit_reset, type: DateTime

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
# Friends

  def friend_player_ids
    worlds.map{|w| w.player_ids }.flatten.uniq
  end

  def friend_players
    friend_player_ids.empty? ? [] :
      MinecraftPlayer.includes(:user).in(_id: friend_player_ids)
  end

  def friend_user_ids
    friend_players.map{|p| p.user_id }.compact
  end

  def friend_users
    @friend_users ||= begin
      friend_user_ids.empty? ? [] :
        User.includes(:minecraft_player).in(_id: friend_user_ids)
    end
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

  def minutes_played
    minecraft_player ? minecraft_player.minutes_played : 0
  end

  def worlds
    minecraft_player ? minecraft_player.worlds : []
  end

  def world_player_counts
    worlds.map{|w| w.player_ids.size }
  end

  def tracking_data
    {
      'beta?' => beta?,
      'created worlds' => created_worlds.count,
      'credits' => credits,
      'facebook?' => facebook_linked?,
      'minutes played' => minutes_played,
      'max world players' => world_player_counts.max,
      'member worlds' => worlds.count,
      'pro?' => pro?,
      'profile' => "https://minefold.com/#{username}",
      'username' => username,
      'verify host' => verification_host,
      'verified?' => verified?,
    }
  end


protected

  def self.chris
    where(username: 'chrislloyd').cache.first
  end

  def self.dave
    where(username: 'whatupdave').cache.first
  end

end
