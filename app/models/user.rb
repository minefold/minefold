class User < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Authentication
  include Concerns::Coins
  include Concerns::Redis


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

  has_many :bonuses

  belongs_to :invited_by, class_name: self.name

  validates_presence_of :username
  validates_uniqueness_of :username, :allow_nil => false, :allow_blank => false


  # NOTE: there arn't any User emails here. They can't be turned off for the
  # moment.
  store :notifications, accessors: [
    :campaign_mailer,
    :server_mailer,
    :session_mailer
  ]

  attr_accessible :campaign_mailer, :server_mailer, :session_mailer

  uniquify :invitation_token, length: 12
  uniquify :verification_token, length: 12

  friendly_id :username, :use => :slugged

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
    players.minecraft.exists?
  end

  def minecraft_link_host
    "#{authentication_token}.verify.minefold.com"
  end

  def minecraft_avatar_url
    "https://minotar.net/helm/#{players.minecraft.first.uid}/50.png"
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


  def watching
    Server.find($redis.smembers(redis_key(:watching)))
  end

  def watching?(server)
    $redis.sismember(redis_key(:watching), server.id)
  end

  def watch(server)
    $redis.multi do |transaction|
      transaction.sadd(redis_key(:watching), server.id)
      transaction.sadd(server.redis_key(:watchers), id)
    end
  end

  def unwatch(server)
    $redis.multi do |transaction|
      transaction.srem(redis_key(:watching), server.id)
      transaction.srem(server.redis_key(:watchers), id)
    end
  end

end
