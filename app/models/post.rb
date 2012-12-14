class Post < ActiveRecord::Base
  belongs_to :server
  belongs_to :author, class_name: 'User'

  attr_accessible :body

  after_create :create_activity

  def create_activity
    Activities::CreatedPost.publish(self)
  end

end
