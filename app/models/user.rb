class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  BILLING_PERIOD = 1.minute
  FREE_HOURS     = 1

  PLANS = %W{free pro}

  field :email,          type: String
  field :username,       type: String
  field :safe_username,  type: String
  slug  :username,       index: true

  field :plan, type: String, default: 'free'

  field :customer_id,    type: String

  field :host, default: 'pluto.minefold.com'

  field :staff,          type: Boolean, default: false

  field :credits,        type: Integer, default: 0
  field :minutes_played, type: Integer, default: 0
  embeds_many :credit_events

  has_many :orders

  belongs_to :current_world, class_name: 'World'
  has_many :created_worlds, class_name: 'World', inverse_of: :creator

  has_and_belongs_to_many :whitelisted_worlds,
                          inverse_of: :whitelisted_players,
                          class_name: 'World'

  embeds_many :wall_items, as: :wall

  attr_accessor :email_or_username


# VALIDATIONS

  validates_presence_of :username
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_confirmation_of :password
  validates_numericality_of :credits, greater_than_or_equal_to: 0
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0
  validates_inclusion_of :plan, in: PLANS

# SECURITY

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation,
                  # TODO: Think more about the security implications of this.
                  :plan,
                  :card_token

  # Virtual
  attr_accessible :email_or_username,
                  :remember_me


# PLANS

  attr_reader :card_token

  after_save do
    if plan_changed?
      if free?
        customer.cancel_subscription
      else
        customer.update_subscription plan: plan, prorate: true
      end
    end
  end

  def customer
    @customer ||= if customer_id?
      Stripe::Customer.retrieve(customer_id)
    else
      Stripe::Customer.create(description: username, email: email).tap do |c|
        self.customer_id = c.id
      end
    end
  end

  def card_token=(token)
    customer.card = token
    customer.save
    token
  end

  def pro?
    plan == 'pro'
  end

  def free?
    plan == 'free'
  end

  def customer?
    customer_id?
  end

  def self.paid_for_minecraft?(username)
    response = RestClient.get "http://www.minecraft.net/haspaid.jsp", params: {user: username}
    return response == 'true'
  rescue RestClient::Exception
    false
  end



# CREDITS

  # scope :free, where(:orders.size => 0)

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

  mount_uploader :avatar, AvatarUploader

  def fetch_avatar!
    self.remote_avatar_url = "http://minecraft.net/skin/#{safe_username}.png"
  rescue OpenURI::HTTPError # User has a default skin
  end

  def async_fetch_avatar!
    Resque.enqueue(FetchAvatar, id)
  end

  # def avatar_url(options={width:24})
  #   "http://minotar.com/avatar/#{safe_username}/#{options[:width]}.png"
  # end

  before_save do
    Resque.enqueue(FetchAvatar, id) if safe_username_changed?
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

  def worlds
    created_worlds | whitelisted_worlds
  end

  def first_sign_in?
    sign_in_count <= 1
  end

  def to_param
    slug
  end

  def as_json(options={})
    super(options).merge(
      avatar_head_24_url: avatar.head.s24.url
    )
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
