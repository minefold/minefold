class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :world
  mount_uploader :file, PhotoUploader
  
  belongs_to :creator, class_name: 'User'
  
  field :title
  field :caption
  
  def index
    world.photos.index(self)
  end
  
  def previous?
    index > 0
  end
  
  def next?
    index < (world.photos.length - 1)
  end
  
  def previous
    world.photos[index - 1]
  end
  
  def next
    world.photos[index + 1]
  end
  
end
