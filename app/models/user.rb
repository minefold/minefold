require './lib/redis_key'

class User < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Authentication
  include Concerns::Coins

  attr_accessible :username, :email, :first_name, :last_name, :name, :avatar,
                  :password, :password_confirmation, :remove_avatar,
                  :avatar_cache, :distinct_id, :invited_by_id


  acts_as_paranoid

  has_many(:accounts, :autosave => true) do

    def mojang
      where(type: Accounts::Mojang)
    end

    def facebook
      where(type: Accounts::Facebook)
    end

    def steam
      where(type: Accounts::Steam)
    end

    def linked?(type)
      where(type: type).exists?
    end

  end

  has_many :created_servers, class_name: 'Server', foreign_key: :creator_id

  has_and_belongs_to_many :watching,
    class_name: 'Server',
    join_table: 'watchers',
    uniq: true

  has_and_belongs_to_many :starred,
    class_name: 'Server',
    join_table: 'stars',
    uniq: true

  has_many :memberships
  has_many :servers, through: :memberships


  has_many :bonuses

  belongs_to :invited_by, class_name: self.name

  validates_presence_of :username
  validates_uniqueness_of :username, :allow_nil => false, :allow_blank => false


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

  def minecraft_link_host
    "#{verification_token}.verify.minefold.com"
  end


  def invited?
    invited_by_id?
  end

  def channel_key
    [self.class.name.downcase, id.to_s].join('-')
  end

  def private_channel_key
    "private-#{channel_key}"
  end

# --

  before_create :generate_distinct_id

  def generate_distinct_id
    self.distinct_id ||= SecureRandom.uuid
  end

end
