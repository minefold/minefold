require 'brock'
require 'access_policies'

class Funpack < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  scope :published, -> { where('published_at is not ?', nil) }

  attr_accessible :name,
                  :creator,
                  :info_url,
                  :description,
                  :party_cloud_id,
                  :imports,
                  :slug,
                  :game_id,
                  :settings_schema,
                  :published_at,
                  :bolt_allocations,
                  :player_allocations

  belongs_to :creator, class_name: 'User'

  has_many :servers

  serialize :settings_schema, JSON

  def settings
    filtered = settings_schema.reject{|f| f['name'] == 'max-players' }
    Brock::Schema.new(filtered)
  end

  def published?
    !published_at.nil?
  end

  def new?
    published_at >= 2.weeks.ago
  end

  AccessPolicies = {
    0 => PublicAccessPolicy,
    1 => MinecraftWhitelistAccessPolicy,
    2 => MinecraftBlacklistAccessPolicy,
    3 => TeamFortress2PasswordAccessPolicy
  }

  def access_policies
    AccessPolicies.slice(*access_policy_ids)
  end

end
