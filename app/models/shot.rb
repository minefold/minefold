class Shot < ActiveRecord::Base
  mount_uploader :file, ShotUploader

  belongs_to :server
  belongs_to :uploader, class_name: 'User'

  def create_activity
    Activities::Shot.publish(self)
  end

end
