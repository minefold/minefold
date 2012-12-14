class Activity < ActiveRecord::Base

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true

  after_create :publish_async

  def score
    created_at.to_i
  end

  def interested
    [actor, subject, target].compact
  end

  def publish
    interested.each do |obj|
      stream = ActivityStream.new(obj, $redis)
      stream.add(self)
    end
  end

  def publish_async
    Resque.enque(PublishActivityJob, self.class, id)
  end

end
