class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :commentable, polymorphic: true
  # validates_presence_of :commentable

  belongs_to :author, class_name: 'User'
  # validates_presence_of :author

  field :text, type: String

end
