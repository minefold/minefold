class Activity < ActiveRecord::Base

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true

  after_create :publish_to_target

  after_create :broadcast_async

  def self.publish(*args)
    a = self.for(*args)
    a.save
    a
  end

  def score
    created_at.to_i
  end

  # Default noop to be overriden by subclasses
  def interested
    []
  end

  def publish_to(obj)
    # obj.activity_stream.add(self)
    ActivityStream.new(obj, $redis).add(self)
  end

  def publish_to_target
    publish_to(self.target)
  end

  def broadcast
    interested.each do |obj|
      publish_to(obj)
    end
  end

  def broadcast_async
    Resque.enqueue(BroadcastActivityJob, self.class.name, id)
  end

  def to_partial_path
    File.join('activities', self.class.name.demodulize.underscore)
  end

end
