require 'brock'
require 'access_policies'

class Funpack < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  scope :published, -> { where('published_at is not ?', nil) }

  attr_accessible :name,
                  :slug,
                  :access_policy_ids,
                  :creator,
                  :info_url,
                  :description,
                  :default_access_policy_id,
                  :party_cloud_id,
                  :imports,
                  :persistent,
                  :maps,
                  :settings_schema,
                  :published_at,
                  :plan_allocations

  belongs_to :creator, class_name: 'User'

  has_many :servers
  has_many :plan_allocations

  serialize :settings_schema, JSON

  def settings
    filtered = settings_schema.reject{|f| f['name'] == 'max-players' }
    Brock::Schema.new(filtered)
  end

  def published?
    !published_at.nil?
  end

  def recent?
    published_at > 2.weeks.ago
  end

  def instructions?
    ['minecraft', 'bukkit-essentials'].include?(slug)
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

  def default_access_policy
    AccessPolicies[default_access_policy_id]
  end

end
