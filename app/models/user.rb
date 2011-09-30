class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  BILLING_PERIOD = 1.minute
  FREE_HOURS     = 1

  field :email,          type: String
  field :username,       type: String
  field :safe_username,  type: String
  slug  :username,       index: true

  field :customer_id,    type: String
  alias_method :customer?, :customer_id?

  field :host, default: 'pluto.minefold.com'

  field :staff,          type: Boolean, default: false

  field :credits,        type: Integer, default: 0
  field :minutes_played, type: Integer, default: 0
  embeds_many :credit_events

  has_many :orders

  belongs_to :current_world, class_name: 'World'
  has_many :created_worlds, class_name: 'World', inverse_of: :creator
  has_many :owned_worlds, class_name: 'World', inverse_of: :owner

  has_and_belongs_to_many :memberships, inverse_of: :members, class_name: 'World'

  embeds_many :wall_items, as: :wall

  # field :total_referrals, type: Integer, default: 10
  # embeds_many :referrals
  # belongs_to  :referrer, class_name: 'User', inverse_of: :user

  attr_accessor :email_or_username


# VALIDATIONS

  validates_presence_of :username
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_confirmation_of :password
  validates_numericality_of :credits, greater_than_or_equal_to: 0
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0

# SECURITY

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation

  # Virtual
  attr_accessible :email_or_username,
                  :remember_me


# SIGNUPS

  SPOTS = 500

  def self.free_spots
    SPOTS - count
  end

  def self.free_spots?
    free_spots > 0
  end


# CREDITS

  scope :free, where(:orders.size => 0)

  # Gives away the free credits and starts off the credit history
  after_create do
    increment_credits! FREE_HOURS.hours / BILLING_PERIOD
  end

  def increment_credits!(n, time=Time.now.utc)
    event = CreditEvent.new(delta: n.to_i)

    self.class.collection.update({_id: id}, {
      '$inc' => {
        credits: n.to_i
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

  class Skin < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    def fog_directory
      "minefold.#{Rails.env}.users.skins"
    end

    version :avatar do
      process :crop_head!

      version(:s60) do
        process :sample => [60, 60]
      end

      version(:s48) do
        process :sample => [48, 48]
      end

      version :s36 do
        process :sample => [36, 36]
      end

      version :s24 do
        process :sample => [24, 24]
      end

      version :s18 do
        process :sample => [18, 18]
      end

      version :s16 do
        process :sample => [16, 16]
      end
    end

    def sample(width, height)
      manipulate! do |img|
        img.sample "%ix%i" % [width, height]
        img = yield(img) if block_given?
        img
      end
    end

    def crop_head!
      manipulate! do |img|
        img.crop "%ix%i+%i+%i" % [8, 8, 8, 8]
        img = yield(img) if block_given?
        img
      end
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end
  end

  mount_uploader :skin, Skin

  def fetch_skin!
    self.remote_skin_url = "http://minecraft.net/skin/#{safe_username}.png"
  rescue OpenURI::HTTPError # User has a default skin
  end

  def async_fetch_skin!
    Resque.enqueue(FetchSkin, id)
  end

  def avatar_url(options={width:24})
    "http://minotar.com/avatar/#{safe_username}/#{options[:width]}.png"
  end

  before_save do
    Resque.enqueue(FetchSkin, id) if safe_username_changed?
  end

# REFERRALS

# USER_REFERRAL_BONUS = 1.hour
# FRIEND_REFERRAL_BONUS = 4.hours
#
# def referrals_left?
#   referrals.length < total_referrals
# end
#
# def referrals_left
#   total_referrals - referrals.length
# end

#   def verify!
#     decrement referrals: 1
#     invite.set claimed: true
#
#     add_credits USER_REFERRAL_BONUS
#     invite.creator.add_credits FRIEND_REFERRAL_BONUS
#   end

# OTHER

  def playable_worlds
    owned_worlds | memberships
  end

  def first_sign_in?
    sign_in_count <= 1
  end

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
