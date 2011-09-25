class Photo
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  class Uploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    process :resize_to_fit => [800, 600]

    version :thumb do
      process :resize_to_fit => [140, 140]
    end

    version :tiny do
      process :resize_to_fit => [40, 40]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end
  end

  mount_uploader :image, Uploader
  validates_presence_of :image

  embedded_in :world
end