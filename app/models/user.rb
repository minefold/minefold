class User < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :username, :email, :first_name, :last_name, :name, :avatar,
                  :password, :password_confirmation, :remove_avatar,
                  :avatar_cache, :distinct_id, :invited_by_id


  acts_as_paranoid

  has_many :players, :autosave => true do

    def minecraft
      includes(:game).where('games.name' => 'Minecraft')
    end

  end

  has_many :memberships
  has_many :servers, through: :memberships
  has_many :created_servers, class_name: 'Server', foreign_key: :creator_id

  has_many :bonus_claims
  belongs_to :invited_by, class_name: self.name

  validates_presence_of :username
  validates_uniqueness_of :username, :allow_nil => false, :allow_blank => false


  validates_presence_of :credits
  validates_numericality_of :credits

  validates_uniqueness_of :facebook_uid, :allow_nil => true


  # NOTE: there arn't any User emails here. They can't be turned off for the
  # moment.
  store :notifications, accessors: [
    :campaign_mailer,
    :server_mailer,
    :session_mailer
  ]

  attr_accessible :campaign_mailer, :server_mailer, :session_mailer

  uniquify :invitation_token, length: 12

  friendly_id :username, :use => :slugged

  devise :database_authenticatable, :token_authenticatable, :omniauthable,
    :confirmable, :recoverable, :registerable, :rememberable, :trackable,
    :validatable, reconfirmable: true

  # Lets users login with both their email or their username
  attr_accessor :email_or_username

  # Everybody gets an authentication token for quick access from emails
  before_save :ensure_authentication_token


  mount_uploader :avatar, AvatarUploader do
    def store_dir
      File.join(model.class.name.downcase.pluralize, mounted_as.to_s, model.id.to_s)
    end
  end

  def name
    if super.present?
      super
    else
      [first_name, last_name].compact.join(' ')
    end
  end

  def name?
    (super && name.present?) || (first_name? || last_name?)
  end

  def conversational_name
    first_name || username
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

  def minecraft_link_host
    "#{authentication_token}.verify.minefold.com"
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
    # TODO See if this could do with some refactoring
    self.class.update_counters(self.id, credits: n) == 1
  end


  def send_notification_for?(klass)
    key = klass.name.underscore.to_sym
    notifications[key] == true || notifications[key] == '1'
  end

  def channel_key
    [self.class.name.downcase, id.to_s].join('-')
  end

  def private_channel_key
    "private-#{channel_key}"
  end

  # Finds any user that matches the auth details supplied by Facebook. The current_user is passed in as an optimisation so a second query doesn't have to be made.
  def self.find_for_facebook_oauth(auth, current_user=nil)
    if current_user && current_user.facebook_uid == auth['uid']
      current_user
    else
      where(facebook_uid: auth['uid']).first
    end
  end


  def self.new_with_session(params, session)
    super.tap do |user|
      # Extract stored Mixpanel distinct ids
      if session['distinct_id'].present?
        user.distinct_id = session['distinct_id']
      end

      if session['invitation_token'].present?
        invited_by = User.find_by_invitation_token(session['invitation_token'])

        if invited_by
          user.invited_by = invited_by
        end
      end

      # Extract stored Facebook data (if any)
      data = session['devise.facebook_data']

      if data and data['extra'] and data['extra']['raw_info']
        user.update_facebook_auth(data)
      end
    end
  end

  def update_facebook_auth(auth)
    raw_attrs = auth['extra']['raw_info']

    self.class.extract_facebook_attrs(raw_attrs).each do |attr, val|
      # This is horrible and ugly and makes babies cry, but I'm not sure of a better way of doing it with ActiveRecord.
      previous_val = self.send(attr)
      (previous_val && previous_val.present?) || self.send("#{attr}=", val)
    end

    # TODO Possibly be smart with this
    # if self.email == raw_attrs['email'] and raw_attrs['verified']
    #   self.skip_confirmation!
    # end
  end

  MIN_CREDITS = 600
  CREDIT_FAIRY_PERIOD = 30.days # Ewww

  scope :low_credit, where(
    arel_table[:credits].lt(MIN_CREDITS))

  scope :needs_magic_fairy_dust, low_credit.where(
    arel_table[:last_credit_fairy_visit_at].eq(nil).or(
      arel_table[:last_credit_fairy_visit_at].lt(CREDIT_FAIRY_PERIOD.ago)))

  def gift_credits
    if credits < MIN_CREDITS
      self.credits = MIN_CREDITS
      self.last_credit_fairy_visit_at = Time.now
    end
  end

  def next_credit_fairy_visit_at
    if last_credit_fairy_visit_at?
      last_credit_fairy_visit_at
    else
      created_at
    end + CREDIT_FAIRY_PERIOD
  end



private

  def self.extract_facebook_attrs(attrs)
    { username: attrs['username'],
      email: attrs['email'],
      first_name: attrs['first_name'],
      last_name:  attrs['last_name'],
      name: attrs['name'],
      locale: attrs['locale'],
      timezone: attrs['timezone'],
      gender: attrs['gender']
    }
  end

end
