class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  BILLING_PERIOD = 1.minute

  field :email,          type: String
  field :username,       type: String
  field :safe_username,  type: String
  slug  :username,       index: true

  field :host,           default: 'pluto.minefold.com'

  field :credits,        type: Integer, default: Plan::DEFAULT.credits
  field :minutes_played, type: Integer, default: 0
  embeds_many :credit_events


  attr_accessor :stripe_token
  attr_accessor :coupon

  field :stripe_id,       type: String
  field :plan,            type: String, default: Plan::DEFAULT.stripe_id
  embeds_one :card

  belongs_to :invite

  belongs_to :current_world, class_name: 'World', inverse_of: nil
  has_many :created_worlds, class_name: 'World', inverse_of: :creator

  has_and_belongs_to_many :whitelisted_worlds,
                          inverse_of: :whitelisted_players,
                          class_name: 'World'

  embeds_many :wall_items, as: :wall

  attr_accessor :email_or_username

  FREE_HOURS = Plan.free.hours

# Finders

  index :email, unique: true

  def self.by_email(email)
    where(email: sanitize_email(email))
  end

  index :safe_username, unique: true

  def self.by_username(username)
    where(safe_username: sanitize_username(username))
  end

  def self.by_email_or_username(str)
    any_of(
      {safe_username: sanitize_username(str)},
      {email: sanitize_email(str)}
    )
  end

  index :stripe_id, unique: true

  def self.by_stripe_id(stripe_id)
    where(stripe_id: stripe_id)
  end


# Validations

  validates_presence_of :username
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_confirmation_of :password
  validates_numericality_of :credits
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0
  validates_inclusion_of :plan, in: Plan.stripe_ids, allow_blank: true


# Security

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation,
                  :plan, # TODO: Think more about the security implications of this.
                  :invite

  attr_accessible :stripe_token,
                  :email_or_username,
                  :remember_me

# Plans

  def free?
    plan == 'free'
  end

  def customer?
    stripe_id?
  end

  def customer_description
    [id, safe_username].join('-')
  end

  def customer
    Stripe::Customer.retrieve(stripe_id)
  end

  def update_subscription!
    if plan.nil?
      # TODO Should we cancel at period end?
      # customer.cancel_subscription at_period_end: true
      customer.cancel_subscription
    else
      customer.update_subscription plan: plan, coupon: coupon, card: stripe_token, prorate: false
      self.credits = [credits, Plan.find(plan).credits].max
    end
  end
  
  def update_card
    self.card = Card.new_from_stripe(customer.active_card)
  end
  
  def create_stripe_customer
    self.stripe_id = Stripe::Customer.create(
      description: customer_description,
      email: email,
      plan: plan,
      coupon: coupon
    ).id
  end

  after_create do
    create_stripe_customer
    save!
  end

  before_save do
    update_subscription! if customer? and plan_changed?
  end

  before_save do
    update_card if stripe_token
  end


  def self.paid_for_minecraft?(username)
    response = RestClient.get "http://www.minecraft.net/haspaid.jsp", params: {user: username}
    return response == 'true'
  rescue RestClient::Exception
    false
  end



# CREDITS

  # Gives away the free credits and starts off the credit history
  # after_create do
  #   increment_credits!
  # end
  #
  # before_validation(on: :create) do
  #   n = FREE_HOURS.hours / BILLING_PERIOD
  #   self.credits = n
  #
  # end

  before_create do
    self.credit_events.build(delta: self.credits)
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

  def time_remaining
    [hours, minutes]
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

  before_save do
    async_fetch_avatar! if safe_username_changed?
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
    (created_worlds | whitelisted_worlds).sort_by do |world|
      world.creator.safe_username + world.name
    end
  end

  def first_sign_in?
    sign_in_count <= 1
  end

  def to_param
    slug
  end

  def as_json(options={})
    {
      avatar_head_24_url: avatar.head.s24.url,
      avatar_head_60_url: avatar.head.s60.url,
      id: id
    }.merge(super(options))
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

private

  def self.sanitize_username(str)
    str.downcase.strip
  end

  def self.sanitize_email(str)
    str.downcase.strip
  end

end
