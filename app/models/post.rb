class Post < ActiveRecord::Base
  belongs_to :server
  belongs_to :author, class_name: 'User'

  attr_accessible :body

  after_create :create_activity

  # TODO Implement this validation
  #      Remove previously empty posts
  #      Show client-side error
  # validates :body, presence: true,
  #                  length: {minimum: 1}

  def create_activity
    Activities::Post.publish(self)
  end

end
