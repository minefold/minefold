class Post < ActiveRecord::Base
  belongs_to :server
  belongs_to :author, class_name: 'User'

  attr_accessible :body
end
