class Activity < ActiveRecord::Base

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true

  before_save :cache_display_data

  after_create :publish_to_watchers

  def score
    updated_at.to_i
  end

  def display_data
    {}
  end

  def cache_display_data
    self.data ||= display_data
  end

  def interested
    [actor, subject, target].compact
  end

  def self.perform!(id)
  end

  def async_publish!
  end

  def publish_to_watchers
    Resque.enqueue(PublishActivityJob, self.class.name, self.id)
  end

end
