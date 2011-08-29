class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia
  include Gravtastic


  BILLING_PERIOD = 1.minute
  FREE_HOURS     = 1
#   MAX_REFERRALS  = 10

  field :email,          type: String
  field :username,       type: String
  field :safe_username,  type: String
  slug  :username,       index: true

  field :staff,          type: Boolean, default: false

  field :credits,        type: Integer, default: 0
  field :minutes_played, type: Integer, default: 0
  embeds_many :credit_events

  has_many :orders

  has_one :current_world, class_name: 'World'
  has_many :worlds

  has_many :wall_items, as: :wall

  field :referrals_sent, type: Integer, default: 0
  embeds_many :referrals
  embeds_one  :referral


# VALIDATIONS

  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_confirmation_of :password
  validates_numericality_of :credits, greater_than_or_equal_to: 0
  validates_numericality_of :minutes_played, greater_than_or_equal_to: 0
  validates_numericality_of :referrals_sent, greater_than_or_equal_to: 0

# SECURITY

  attr_accessible :email,
                  :username,
                  :password,
                  :password_confirmation


# CREDITS

  scope :free, where(:orders.size => 0)

  # Gives away the free credits and starts off the credit history
  after_initialize do
    self.credits += FREE_HOURS.hours / BILLING_PERIOD
    self.credit_events.build(delta: credits)
  end


  def increment_credits!(n, time=Time.now.utc)
    event = CreditEvent.new(delta: n)

    self.class.collection.update({_id: id}, {
      '$inc' => {
        credits: n
      },
      '$push' => {
        credit_events: event.attributes.merge(
          created_at: time,
          updated_at: time
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


# AVATARS

  gravtastic format: :png


# REFERRALS

  USER_REFERRAL_BONUS = 1.hour
  FRIEND_REFERRAL_BONUS = 4.hours

#   def verify!
#     decrement referrals: 1
#     invite.set claimed: true
#
#     add_credits USER_REFERRAL_BONUS
#     invite.creator.add_credits FRIEND_REFERRAL_BONUS
#   end

protected

  def self.chris
    first(username: 'chrislloyd').cache
  end

  def self.dave
    first(username: 'whatupdave').cache
  end

end
