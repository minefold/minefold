class User < ActiveRecord::Base
  extend FriendlyId

  has_many :players
  has_many :memberships
  has_many :servers, through: :memberships
  has_many :created_servers, class_name: 'Server', foreign_key: :creator_id

  validates_presence_of :username
  validates_uniqueness_of :username


  validates_presence_of :credits
  validates_numericality_of :credits

  # NOTE: there arn't any User emails here. They can't be turned off for the
  # moment.
  store :email_prefs, accessors: [
    :server_emails,
    :membership_emails,
    :membership_request_emails,
    :session_emails
  ]

  friendly_id :username, :use => :slugged


  devise :database_authenticatable, :token_authenticatable, :omniauthable,
    :confirmable, :recoverable, :registerable, :rememberable, :trackable,
    :validatable

  # Lets users login with both their email or their username
  attr_accessor :email_or_username

  # Everybody gets an authentication token
  before_save :ensure_authentication_token



  def name
    [first_name, last_name].join(' ')
  end

  def pro?
  end

  def minecraft_linked?
    players.includes(:game).where('games.name' => 'Minecraft').exists?
  end

  def self.find_for_database_authentication(conditions)
    email_or_username = conditions.delete(:email_or_username)

    where(arel_table[:email].eq(email_or_username).or(
        arel_table[:username].eq(email_or_username))).first
  end

  def self.find_or_initialize_from_facebook(access_token)
    find_from_facebook(access_token) || initialize_from_facebook(access_token)
  end

  def self.find_from_facebook(access_token)
    where(arel_table[:facebook_uid].eq(access_token.uid).or(
      arel_table[:email].eq(access_token.info.email))).first
  end

  def self.initialize_from_facebook(access_token)
    new(extract_facebook_attributes(access_token.extra.raw_info)).tap do |u|
      u.password, u.password_confirmation = Devise.friendly_token[0,20]
      u.skip_confirmation!
    end
  end


  def customer
    if customer_id?
      Stripe::Customer.retrieve(customer_id)
    end
  end

  def create_customer(card_token)
    c = Stripe::Customer.create(
      card: card_token,
      email: self.email,
      description: self.id.to_s
    )
    self.customer_id = c.id
  end
  
  # Stub
  # def credits
  #   cr * 60
  # end
  
  # Atomically increment credits
  # Warning: doesn't update the model's internal representation.
  def increment_credits!(n)
    self.class.update_counters(self.id, credits: n) == 1
  end


  def channel_key
    [self.class.name.downcase, id.to_s].join('-')
  end

  def private_channel_key
    "private-#{channel_key}"
  end

private

  def self.extract_facebook_attributes(info)
    { username: info.username,
      email: info.email,
      first_name: info.first_name,
      last_name:  info.last_name,
      locale: info.locale,
      timezone: info.timezone,
      gender: info.gender
    }
  end

end
