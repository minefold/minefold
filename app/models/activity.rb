class Activity < ActiveRecord::Base

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true

  def score
    updated_at.to_i
  end

  after_create :publish_to_watchers

  def publish_to_watchers
    Resque.enqueue(PublishActivityJob, self.class.name, self.id)
  end

  def to_partial_path
    File.join('activities', self.class.name.demodulize.underscore)
  end

end
