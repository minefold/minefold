class MinecraftAccount
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  belongs_to :user


# ---
# Identity


  def self.sanitize_username(str)
    str.strip.downcase
  end

  def self.blacklist
    @blacklist ||= File.read(Rails.root.join('config', 'blacklist.txt'))
      .split("\n")
  end


  field :username, type: String
  attr_accessible :username
  validates_length_of :username, within: 1..16
  validates_uniqueness_of :username, case_sensitive: false
  validate :blacklisted_username

  field :slug, type: String
  index :slug

  def username=(str)
    super(str.strip)
    self.slug = self.class.sanitize_username(str)
  end

  def blacklisted_username
    if self.class.blacklist.include?(username)
      errors.add(:username, 'is reserved')
    end
  end


# ---
# Unlocking

  field :unlock_code, type: String, default: -> { rand(36 ** 4).to_s(36) }


# ---
# Stats


  # TODO This constant should be somewhere else. It's used by both User and
  #   MinecraftAccount and in Prism.
  TICK_PERIOD = 1.minute

  field :ticks, type: Integer, default: 0


end
