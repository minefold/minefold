class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true

  index :source
  index :target
end
