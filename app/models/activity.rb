class Activity < ActiveRecord::Base

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true

  after_create :publish_async

  def self.publish(*args)
    a = self.for(*args)
    a.save
    a
  end

  def score
    created_at.to_i
  end

  def interested
    [actor, target].compact
  end

  def publish
    interested.each do |obj|
      stream = ActivityStream.new(obj, $redis)
      stream.add(self)
    end
  end

  def publish_async
    Resque.enqueue(PublishActivityJob, self.class.name, id)
  end

  def to_partial_path
    File.join('activities', self.class.name.demodulize.underscore)
  end

end
