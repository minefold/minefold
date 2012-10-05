class User < ActiveRecord::Base
  extend FriendlyId

  has_many :players do
    
    def minecraft
      includes(:game).where('games.name' => 'Minecraft')
    end
    
  end
  
  has_many :memberships
  has_many :servers, through: :memberships
  has_many :created_servers, class_name: 'Server', foreign_key: :creator_id
  
  has_many :reward_claims
  has_many :rewards, :through => :reward_claims
  

  validates_presence_of :username
  validates_uniqueness_of :username


  validates_presence_of :credits
  validates_numericality_of :credits

  # NOTE: there arn't any User emails here. They can't be turned off for the
  # moment.
  store :mail_prefs, accessors: [
    :newsletter_mailer,
    :server_mailer,
    :session_mailer
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

  def facebook_linked?
    facebook_uid?
  end
  
  def facebook_avatar_url
    "https://graph.facebook.com/#{facebook_uid}/picture?return_ssl_resources=1&type=square"
  end

  def minecraft_linked?
    players.includes(:game).where('games.name' => 'Minecraft').exists?
  end
  
  def minecraft_avatar_url
    "https://minotar.net/helm/#{players.minecraft.first.uid}/50.png"
  end
  
  

  def self.find_for_database_authentication(conditions)
    email_or_username = conditions.delete(:email_or_username)

    where(arel_table[:email].eq(email_or_username).or(
        arel_table[:username].eq(email_or_username))).first
  end

  def self.find_or_initialize_from_facebook(access_token)
    find_from_facebook(access_token) || initialize_from_facebook(access_token)
  end

  def self.find_from_facebook(facebook_uid)
    where(facebook_uid: facebook_uid).first
  end

  # def self.initialize_from_facebook(access_token)
  #   new(extract_facebook_attributes(access_token.extra.raw_info)).tap do |u|
  #     u.password, u.password_confirmation = Devise.friendly_token[0,20]
  #     u.skip_confirmation!
  #   end
  # end
  
  def update_facebook_attributes(full_attrs)
    self.class.extract_facebook_attributes(full_attrs).each do |attr, val|
      self[attr] ||= val
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
  
  # Atomically increment credits
  # Warning: doesn't update the model's internal representation.
  def increment_credits!(n)
    self.class.update_counters(self.id, credits: n) == 1
  end
  
  
  def wants_mail_for?(klass)
    key = klass.name.underscore.to_sym
    mail_prefs[key] == true || mail_prefs[key] == '1'
  end

  def channel_key
    [self.class.name.downcase, id.to_s].join('-')
  end

  def private_channel_key
    "private-#{channel_key}"
  end

private

  def self.extract_facebook_attributes(info)
    { first_name: info.first_name,
      last_name:  info.last_name,
      name: info.name,
      locale: info.locale,
      timezone: info.timezone,
      gender: info.gender
    }
  end

end
